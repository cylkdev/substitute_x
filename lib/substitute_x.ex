defmodule SubstituteX do
  @moduledoc """
  SubstituteX provides a standardized API for comparing
  and transforming terms.

  ### Options

    * `:engine` - The engine adapter that implements the logic for evaluating terms.
      Defaults to `SubstituteX.CommonComparison`.

  ### Replacement

  To change a `term` you must specify a `replacement` which can be
  one of the following:

    - A literal, for example a `string` or `integer`.

    - A `0-arity` function invoked as `func.()`.

    - A `1-arity` function invoked as `func.(left)`.

    - A `2-arity` function invoked as `func.(left, operator)`.

    - A `3-arity` function invoked as `func.(left, operator, right)`.
  """

  alias SubstituteX.Engine

  @type opts :: keyword()
  @type operator :: atom()
  @type replacement :: function() | any()
  @type definition :: map() | keyword()
  @type change_params :: definition() |
    {definition(), replacement()} |
    list(definition() |
    {definition(), replacement()})

  @doc """
  Returns the evaluation of the expression `<left> <operator> <right>`.

  ### Examples

      iex> SubstituteX.evaluate?(1, :===, 1)
      true
  """
  @spec evaluate?(left :: any(), operator :: any(), right :: any(), opts :: opts()) :: true | false
  @spec evaluate?(left :: any(), operator :: any(), right :: any()) :: true | false
  def evaluate?(left, operator, right, opts \\ []) do
    Engine.evaluate?(left, operator, right, opts)
  end

  @doc """
  Returns true if all params matches the term.

  ### Examples

      iex> SubstituteX.compare?("foo", :*)
      true

      iex> SubstituteX.compare?(:name, :name)
      true

      iex> SubstituteX.compare?(%{body: "foo"}, %{body: "foo"})
      true

      iex> SubstituteX.compare?(%{body: "foo"}, %{body: %{=~: "f"}})
      true
  """
  @spec compare?(left :: any(), right :: any(), opts :: opts()) :: true | false
  @spec compare?(left :: any(), right :: any()) :: true | false
  def compare?(left, right, opts \\ [])

  def compare?(left, params, opts) when is_map(params) do
    compare_term(left, Map.to_list(params), opts)
  end

  def compare?(left, right, opts) do
    compare_term(left, right, opts)
  end

  defp compare_term(_left, :*, _opts) do
    true
  end

  defp compare_term(left, [head | tail], opts) do
    if Enum.any?(tail) do
      with true <- compare_term(left, head, opts) do
        compare_term(left, tail, opts)
      end
    else
      compare_term(left, head, opts)
    end
  end

  defp compare_term(left, {key, right_list}, opts) when is_list(right_list) do
    cond do
      Keyword.keyword?(left) -> left |> Keyword.get(key) |> compare_term(right_list, opts)
      is_map(left) -> left |> Map.get(key) |> compare_term(right_list, opts)
      true -> Enum.any?(left, fn term -> compare_term(term, {key, right_list}, opts) end)
    end
  end

  defp compare_term(left, {key, right}, opts) when is_map(right) do
    if Engine.operator?(key, opts) do
      Engine.evaluate?(left, key, right, opts)
    else
      compare_term(left, {key, Map.to_list(right)}, opts)
    end
  end

  defp compare_term(left_list, {key, right}, opts) when is_list(left_list) do
    if Engine.operator?(key, opts) do
      Enum.any?(left_list, fn left ->
        Engine.evaluate?(left, key, right, opts)
      end)
    else
      if Keyword.keyword?(left_list) do
        left_list |> Keyword.get(key) |> compare_term(right, opts)
      else
        Enum.any?(left_list, fn left -> compare_term(left, {key, right}, opts) end)
      end
    end
  end

  defp compare_term(left, {key, right}, opts) when is_map(left) do
    if Engine.operator?(key, opts) do
      Engine.evaluate?(left, key, right, opts)
    else
      left |> Map.get(key) |> compare_term(right, opts)
    end
  end

  defp compare_term(left, {key, right} = tuple, opts) do
    cond do
      Engine.operator?(tuple, opts) -> Engine.evaluate?(left, tuple, nil, opts)
      Engine.operator?(key, opts) -> Engine.evaluate?(left, key, right, opts)
      true -> Engine.evaluate?(left, :===, tuple, opts)
    end
  end

  defp compare_term(left, right, opts) when is_map(right) do
    compare_term(left, Map.to_list(right), opts)
  end

  defp compare_term(left_list, right, opts) when is_list(left_list) do
    Enum.any?(left_list, fn left ->
      compare_term(left, right, opts)
    end)
  end

  defp compare_term(left, right, opts) do
    if Engine.operator?(right) do
      Engine.evaluate?(left, right, nil, opts)
    else
      Engine.evaluate?(left, :===, right, opts)
    end
  end

  @doc """
  Replaces the `left` term with the `replacement` value if the
  evaluation of the expression `<left> <operator> <right>` is
  `true`.

  ### Examples

      iex> SubstituteX.change("hello", :===, "hello", "goodbye")
      "goodbye"

      iex> SubstituteX.change("hello", :===, "not_a_match", "no_change_will_be_made")
      "hello"

      iex> SubstituteX.change("hello", :===, "hello", fn string, _operator, _right -> string <> " world!" end)
      "hello world!"

      iex> SubstituteX.change("hello", :===, "hello", fn string -> string <> " world!" end)
      "hello world!"

      iex> SubstituteX.change("hello", :===, "hello", fn -> "goodbye" end)
      "goodbye"
  """
  @spec change(
    left :: any(),
    operator :: any(),
    right :: any(),
    replacement :: replacement(),
    opts :: keyword()
  ) :: any()
  @spec change(
    left :: any(),
    operator :: any(),
    right :: any(),
    replacement :: replacement()
  ) :: any()
  def change(left, operator, right, replacement, opts \\ [])

  def change(left, operator, right, replacement, opts) do
    if evaluate?(left, operator, right, opts) do
      replace(replacement, left, operator, right)
    else
      left
    end
  end

  @doc """
  Transforms a term or each term in an enumerable that
  matches a pattern in the parameters.

  ### Examples

      iex> SubstituteX.change("foo", %{"foo" => "bar"})
      "bar"

      iex> SubstituteX.change("foo", %{"foo" => %{===: "bar"}})
      "bar"

      iex> SubstituteX.change("foo", [%{"qux" => "bux"}, %{"foo" => "bar"}])
      "bar"

      iex> SubstituteX.change(%{value: "foo"}, %{value: %{"foo" => "bar"}})
      %{value: "bar"}
  """
  @spec change(
    term :: any(),
    params :: change_params(),
    opts :: keyword()
  ) :: any()
  @spec change(
    term :: any(),
    params :: change_params()
  ) :: any()
  def change(term, params, opts \\ [])

  def change(term, params_list, opts) when is_list(params_list) do
    if Keyword.keyword?(params_list) do
      change(term, params_list, opts)
    else
      Enum.reduce(params_list, term, fn params, term ->
        change(term, params, opts)
      end)
    end
  end

  def change(term, {params, replacement}, opts) do
    if compare?(term, params, opts) do
      replace(replacement, term)
    else
      term
    end
  end

  def change(term, params, opts) when is_map(params) and (not is_struct(params)) do
    change_term(term, Map.to_list(params), opts)
  end

  defp change_term(term, [head | tail], opts) do
    term = change_term(term, head, opts)

    if Enum.any?(tail) do
      change_term(term, tail, opts)
    else
      term
    end
  end

  defp change_term(list, {key, right}, opts) when is_list(list) do
    if Keyword.keyword?(list) do
      case Keyword.get(list, key) do
        nil -> list
        term -> Keyword.replace!(list, key, change_term(term, right, opts))
      end
    else
      Enum.map(list, fn term -> change_term(term, {key, right}, opts) end)
    end
  end

  defp change_term(term, {right, [head | tail]}, opts) do
    term = change_term(term, {right, head}, opts)

    if Enum.any?(tail) do
      change_term(term, {right, tail}, opts)
    else
      term
    end
  end

  defp change_term(term, {right, params}, opts) when is_map(params) and (not is_struct(params)) do
    change_term(term, {right, Map.to_list(params)}, opts)
  end

  defp change_term(map, {key, right}, opts) when is_map(map) and (not is_struct(map)) do
    case Map.get(map, key) do
      nil -> map
      term -> Map.put(map, key, change_term(term, right, opts))
    end
  end

  defp change_term(term, {right, {:*, replacement}}, _opts) do
    replace(replacement, term, :*, right)
  end

  defp change_term(term, {right, {operator, replacement}}, opts) do
    if evaluate?(term, operator, right, opts) do
      replace(replacement, term, operator, right)
    else
      term
    end
  end

  defp change_term(term, {:*, replacement}, _opts) do
    replace(replacement, term)
  end

  defp change_term(term, {right, replacement}, opts) do
    if evaluate?(term, :===, right, opts) do
      replace(replacement, term, :===, right)
    else
      term
    end
  end

  defp change_term(term, params, opts) when is_map(params) and (not is_struct(params)) do
    change_term(term, Map.to_list(params), opts)
  end

  defp replace(replacement, left, operator, right) when is_function(replacement, 3) do
    replacement.(left, operator, right)
  end

  defp replace(replacement, left, operator, _right) when is_function(replacement, 2) do
    replacement.(left, operator)
  end

  defp replace(replacement, left, _operator, _right) when is_function(replacement, 1) do
    replacement.(left)
  end

  defp replace(replacement, _left, _operator, _right) when is_function(replacement, 0) do
    replacement.()
  end

  defp replace(replacement, _left, _operator, _right) do
    replacement
  end

  defp replace(replacement, left) when is_function(replacement, 1) do
    replacement.(left)
  end

  defp replace(replacement, _left) when is_function(replacement, 0) do
    replacement.()
  end

  defp replace(replacement, _left) do
    replacement
  end
end
