defmodule SubstituteX do
  @moduledoc File.read!("README.md")

  alias SubstituteX.ComparisonEngine

  @doc """
  Returns `true` if `left` compared to `right` by the given operator is `true`.

  ### Examples

      iex> SubstituteX.matches?(1, :===, 1)
      true
  """
  @spec matches?(
    left :: any(),
    operator :: any(),
    right :: any(),
    opts :: keyword()
  ) :: true | false
  @spec matches?(
    left :: any(),
    operator :: any(),
    right :: any()
  ) :: true | false
  def matches?(left, operator, right, opts \\ []) do
    ComparisonEngine.operator?(operator) and ComparisonEngine.matches?(left, operator, right, opts)
  end

  @doc """
  Returns true if all params matches the term.

  ### Examples

      iex> SubstituteX.compare?("foo", :*)
      true

      iex> SubstituteX.compare?(:name, :name)
      true

      iex> SubstituteX.compare?(1, 1)
      true

      iex> SubstituteX.compare?(~U[2024-09-19 04:18:24Z], ~U[2024-09-19 04:18:24Z])
      true

      iex> SubstituteX.compare?(~U[2024-09-20 04:18:24Z], %{gt: ~U[2024-09-19 04:18:24Z]})
      true

      iex> SubstituteX.compare?(~N[2024-09-20 04:18:24], %{gt: ~N[2024-09-19 04:18:24]})
      true

      iex> SubstituteX.compare?("foo", "foo")
      true

      iex> SubstituteX.compare?(%{body: "foo"}, [])
      false

      iex> SubstituteX.compare?(%{body: "foo"}, %{body: "foo"})
      true

      iex> SubstituteX.compare?(%{post: %{comments: [%{body: "foo"}]}}, %{post: %{comments: %{body: "foo"}}})
      true

      iex> SubstituteX.compare?(%{body: "foo", likes: 10}, %{body: "foo", likes: 10})
      true

      iex> SubstituteX.compare?([body: "foo"], %{body: "foo"})
      true

      iex> SubstituteX.compare?([], [])
      true

      iex> SubstituteX.compare?([], 1)
      false
  """
  @spec compare?(left :: any(), right :: any(), opts :: keyword()) :: true | false
  @spec compare?(left :: any(), right :: any()) :: true | false
  def compare?(left, right, opts \\ [])

  def compare?(left, params, opts) when is_map(params) and (not is_struct(params)) do
    compare?(left, Map.to_list(params), opts)
  end

  def compare?(left, right, opts) do
    recurse_compare(left, right, opts)
  end

  defp recurse_compare(_left, :*, _opts) do
    true
  end

  defp recurse_compare(list, {key, right}, opts) when is_list(list) do
    if Keyword.keyword?(list) do
      case Keyword.get(list, key) do
        nil -> false
        left -> recurse_compare(left, right, opts)
      end
    else
      Enum.all?(list, fn left -> recurse_compare(left, {key, right}, opts) end)
    end
  end

  defp recurse_compare(left, [head | tail], opts) do
    with true <- recurse_compare(left, head, opts) do
      if Enum.any?(tail) do
        recurse_compare(left, tail, opts)
      else
        true
      end
    end
  end

  defp recurse_compare(map, {key, params}, opts) when is_map(params) and (not is_struct(params)) do
    recurse_compare(map, {key, Map.to_list(params)}, opts)
  end

  defp recurse_compare(map, {key, right}, opts) when is_map(map) and (not is_struct(map)) do
    case Map.get(map, key) do
      nil -> false
      left -> recurse_compare(left, right, opts)
    end
  end

  defp recurse_compare(left, {operator, right}, opts) do
    matches?(left, operator, right, opts)
  end

  defp recurse_compare(left, right, opts) do
    matches?(left, :===, right, opts)
  end

  @doc """
  Returns the `replacement` or a new value from the
  `replacement` function if the comparison of `left` and
  `right` using `operator` is true.

  The function returns `{changed?, value}`.

  `changed?` is true if a change was attempted; otherwise,
  it is false.

  `value` may be the initial value, a literal replacement,
  or a term from the `replacement` function.

  ### Replacement

  A replacement can be one of the following:

    - A literal (e.g., "hello").

    - A 0-arity function invoked as `func.()`.

    - A 1-arity function invoked as `func.(left)`.

    - A 2-arity function invoked as `func.(left, operator)`.

    - A 3-arity function invoked as `func.(left, operator, right)`.

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
    replacement :: function() | any(),
    opts :: keyword()
  ) :: any()
  @spec change(
    left :: any(),
    operator :: any(),
    right :: any(),
    replacement :: function() | any()
  ) :: any()
  def change(left, operator, right, replacement, opts \\ [])

  def change(left, operator, right, replacement, opts) do
    if matches?(left, operator, right, opts) do
      replace(replacement, left, operator, right)
    else
      left
    end
  end

  @doc """
  Transforms a term by schema.

  ### Examples

      iex> SubstituteX.change("foo", %{"foo" => "bar"})
      "bar"

      iex> SubstituteX.change("foo", [%{"qux" => "bux"}, %{"foo" => "bar"}])
      "bar"

      iex> SubstituteX.change("foo", %{"foo" => %{===: "bar"}})
      "bar"

      iex> SubstituteX.change("foo", {"foo", "bar"})
      "bar"

      iex> SubstituteX.change("foo", [{"qux", "bux"}, {"foo", "bar"}])
      "bar"

      iex> SubstituteX.change(%{body: "foo"}, %{body: %{"foo" => "bar"}})
      %{body: "bar"}

      iex> SubstituteX.change(%{post: %{comments: [%{body: "foo"}, %{body: "bar"}]}}, %{post: %{comments: %{body: %{"foo" => "qux"}}}})
      %{post: %{comments: [%{body: "qux"}, %{body: "bar"}]}}

      iex> SubstituteX.change(%{body: "foo"}, %{body: %{"foo" => %{===: "bar"}}})
      %{body: "bar"}

      iex> SubstituteX.change([body: "foo"], %{body: %{"foo" => "bar"}})
      [body: "bar"]

      iex> SubstituteX.change([body: "foo"], %{body: %{"foo" => %{===: "bar"}}})
      [body: "bar"]

      iex> SubstituteX.change([post: [comments: [%{body: "foo"}, %{body: "bar"}]]], %{post: %{comments: %{body: %{"foo" => "qux"}}}})
      [post: [comments: [%{body: "qux"}, %{body: "bar"}]]]

      iex> SubstituteX.change(%{body: "foo"}, {%{body: "foo"}, %{body: "bar"}})
      %{body: "bar"}

      iex> SubstituteX.change(%{body: "foo"}, {%{body: "foo"}, fn -> %{body: "bar"} end})
      %{body: "bar"}

      iex> SubstituteX.change(%{body: "foo"}, {%{body: "foo"}, fn %{body: "foo"} -> %{body: "bar"} end})
      %{body: "bar"}

      SubstituteX.change(
        %{post: %{comments: [%{body: "foo"}, %{body: "bar"}]}},
        {
          %{post: %{comments: %{body: %{=~: ~r|.*|}}}},
          fn -> %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}} end
        }
      )
      %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}}

      iex> SubstituteX.change(
      ...>   %{post: %{comments: [%{body: "foo"}, %{body: "bar"}]}},
      ...>   {
      ...>     %{post: %{comments: %{body: :*}}},
      ...>     fn -> %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}} end
      ...>   }
      ...> )
      %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}}
  """
  @spec change(
    left :: any(),
    params :: map() | keyword() | list() | {map(), function() | any()},
    opts :: keyword()
  ) :: any()
  @spec change(
    left :: any(),
    params :: map() | keyword() | list() | {map(), function() | any()}
  ) :: any()
  def change(left, params, opts \\ [])

  def change(left, params_list, opts) when is_list(params_list) do
    if Keyword.keyword?(params_list) do
      change(left, params_list, opts)
    else
      Enum.reduce(params_list, left, fn params, left ->
        change(left, params, opts)
      end)
    end
  end

  def change(left, {params, replacement}, opts) do
    if compare?(left, params, opts) do
      replace(replacement, left)
    else
      left
    end
  end

  def change(left, params, opts) when is_map(params) and (not is_struct(params)) do
    recurse_transform(left, Map.to_list(params), opts)
  end

  defp recurse_transform(left, [head | tail], opts) do
    left = recurse_transform(left, head, opts)

    if Enum.any?(tail) do
      recurse_transform(left, tail, opts)
    else
      left
    end
  end

  defp recurse_transform(list, {key, right}, opts) when is_list(list) do
    if Keyword.keyword?(list) do
      case Keyword.get(list, key) do
        nil -> list
        left -> Keyword.replace!(list, key, recurse_transform(left, right, opts))
      end
    else
      Enum.map(list, fn left -> recurse_transform(left, {key, right}, opts) end)
    end
  end

  defp recurse_transform(left, {right, [head | tail]}, opts) do
    left = recurse_transform(left, {right, head}, opts)

    if Enum.any?(tail) do
      recurse_transform(left, {right, tail}, opts)
    else
      left
    end
  end

  defp recurse_transform(left, {right, params}, opts) when is_map(params) and (not is_struct(params)) do
    recurse_transform(left, {right, Map.to_list(params)}, opts)
  end

  defp recurse_transform(map, {key, right}, opts) when is_map(map) and (not is_struct(map)) do
    case Map.get(map, key) do
      nil -> map
      left -> Map.put(map, key, recurse_transform(left, right, opts))
    end
  end

  defp recurse_transform(left, {right, {:*, replacement}}, _opts) do
    replace(replacement, left, :*, right)
  end

  defp recurse_transform(left, {right, {operator, replacement}}, opts) do
    if matches?(left, operator, right, opts) do
      replace(replacement, left, operator, right)
    else
      left
    end
  end

  defp recurse_transform(left, {:*, replacement}, _opts) do
    replace(replacement, left)
  end

  defp recurse_transform(left, {right, replacement}, opts) do
    if matches?(left, :===, right, opts) do
      replace(replacement, left, :===, right)
    else
      left
    end
  end

  defp recurse_transform(left, params, opts) when is_map(params) and (not is_struct(params)) do
    recurse_transform(left, Map.to_list(params), opts)
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
