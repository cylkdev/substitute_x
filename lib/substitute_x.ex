defmodule SubstituteX do
  @moduledoc File.read!("README.md")

  alias SubstituteX.ComparisonEngine

  @doc """
  Returns true if the schema matches the term

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

  defp recurse_compare(map, [head | []], opts) do
    recurse_compare(map, head, opts)
  end

  defp recurse_compare(map, [head | tail], opts) do
    with true <- recurse_compare(map, head, opts) do
      recurse_compare(map, tail, opts)
    end
  end

  defp recurse_compare([{_key, _value} | _tail] = keyword, {key, right}, opts) do
    if ComparisonEngine.operator?(key, opts) do
      ComparisonEngine.compare?(keyword, key, right, opts)
    else
      case Keyword.get(keyword, key) do
        nil -> false
        left -> recurse_compare(left, right, opts)
      end
    end
  end

  defp recurse_compare([head | []], {key, right}, opts) do
    recurse_compare(head, {key, right}, opts)
  end

  defp recurse_compare([head | tail], {key, right}, opts) do
    with true <- recurse_compare(head, {key, right}, opts) do
      recurse_compare(tail, {key, right}, opts)
    end
  end

  defp recurse_compare(map, {key, right}, opts) do
    if ComparisonEngine.operator?(key, opts) do
      ComparisonEngine.compare?(map, key, right, opts)
    else
      case Map.get(map, key) do
        nil -> false
        left -> recurse_compare(left, right, opts)
      end
    end
  end

  defp recurse_compare(left, right, opts) when is_map(right) and (not is_struct(right)) do
    recurse_compare(left, Map.to_list(right), opts)
  end

  defp recurse_compare(left, right, opts) do
    ComparisonEngine.compare?(left, :===, right, opts)
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

    - A zero-arity function invoked as `func.()`.

    - A one-arity function invoked as `func.(left)`.

    - A two-arity function invoked as `func.(left, operator)`.

    - A three-arity function invoked as `func.(left, operator, right)`.

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
    if ComparisonEngine.compare?(left, operator, right, opts) do
      replace(replacement, left, operator, right)
    else
      left
    end
  end

  # @doc """
  # Transforms a term by schema.

  # ### Options

  #   * `:on_change` - Defines the function's behavior the
  #     first time a value is changed. When set to `:halt`,
  #     the function immediately returns the result of the
  #     change function. If not set to `:halt`, changes
  #     are applied in sequence.

  # ### Examples

  #     iex> SubstituteX.change("foo", %{"foo" => "bar"})
  #     "bar"

  #     iex> SubstituteX.change("foo", [%{"qux" => "bux"}, %{"foo" => "bar"}])
  #     "bar"

  #     iex> SubstituteX.change("foo", %{"foo" => %{===: "bar"}})
  #     "bar"

  #     iex> SubstituteX.change("foo", [{"qux", "bux"}, {"foo", "bar"}])
  #     "bar"

  #     iex> SubstituteX.change(%{body: "foo"}, %{body: %{"foo" => "bar"}})
  #     %{body: "bar"}

  #     iex> SubstituteX.change(%{post: %{comments: [%{body: "foo"}, %{body: "bar"}]}}, %{post: %{comments: %{body: %{"foo" => "qux"}}}})
  #     %{post: %{comments: [%{body: "qux"}, %{body: "bar"}]}}

  #     iex> SubstituteX.change(%{body: "foo"}, %{body: %{"foo" => %{===: "bar"}}})
  #     %{body: "bar"}

  #     iex> SubstituteX.change([body: "foo"], %{body: %{"foo" => "bar"}})
  #     [body: "bar"]

  #     iex> SubstituteX.change([body: "foo"], %{body: %{"foo" => %{===: "bar"}}})
  #     [body: "bar"]

  #     iex> SubstituteX.change([post: [comments: [%{body: "foo"}, %{body: "bar"}]]], %{post: %{comments: %{body: %{"foo" => "qux"}}}})
  #     [post: [comments: [%{body: "qux"}, %{body: "bar"}]]]

  #     iex> SubstituteX.change(%{body: "foo"}, {%{body: "foo"}, %{body: "bar"}})
  #     %{body: "bar"}

  #     iex> SubstituteX.change(%{body: "foo"}, {%{body: "foo"}, fn -> %{body: "bar"} end})
  #     %{body: "bar"}

  #     iex> SubstituteX.change(%{body: "foo"}, {%{body: "foo"}, fn %{body: "foo"} -> %{body: "bar"} end})
  #     %{body: "bar"}

  #     iex> SubstituteX.change(
  #     ...>   %{post: %{comments: [%{body: "foo"}, %{body: "bar"}]}},
  #     ...>   {
  #     ...>     %{post: %{comments: %{body: %{=~: ~r|.*|}}}},
  #     ...>     fn -> %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}} end
  #     ...>   }
  #     ...> )
  #     %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}}

  #     iex> SubstituteX.change(
  #     ...>   %{post: %{comments: [%{body: "foo"}, %{body: "bar"}]}},
  #     ...>   {
  #     ...>     %{post: %{comments: %{body: :*}}},
  #     ...>     fn -> %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}} end
  #     ...>   }
  #     ...> )
  #     %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}}
  # """
  # @spec change(
  #   left :: any(),
  #   schema :: map() | {map(), function() | any()},
  #   opts :: keyword()
  # ) :: any()
  # @spec change(
  #   left :: any(),
  #   schema :: map() | {map(), function() | any()}
  # ) :: any()
  # def change(left, schema, opts \\ [])

  # def change(left, {schema, replacement}, _opts) do
  #   if compare?(left, schema) do
  #     replace(replacement, left)
  #   else
  #     left
  #   end
  # end

  # def change(left, schema, opts) when is_map(schema) do
  #   schema = Map.to_list(schema)

  #   change(left, schema, opts)
  # end


  # def change(left, [head | _tail] = schemas, opts) when is_map(head) or is_list(head) do
  #   Enum.reduce_while(schemas, {false, left}, fn head, {previous_change?, left} ->
  #     {changed?, result} = change(left, head, opts)

  #     halt_on_change? = opts[:on_change] === :halt

  #     signal = if changed? and halt_on_change?, do: :halt, else: :cont

  #     {signal, {previous_change? || changed?, result}}
  #   end)
  # end

  # def change(left, schema, opts) do
  #   recurse_change({false, left}, schema, opts)
  # end

  # def change(left, schema) do
  #   change(left, schema, [])
  # end

  # defp recurse_change({changed?, []}, _value, _opts) do
  #   {changed?, []}
  # end

  # defp recurse_change({changed?, [head | tail]}, value, opts) do
  #   {changed?, result} = recurse_change({changed?, head}, value, opts)

  #   halt_on_change? = opts[:on_change] === :halt

  #   if changed? and halt_on_change? do
  #     {changed?, [result | tail]}
  #   else
  #     {changed?, rest} = recurse_change({changed?, tail}, arg, opts)

  #     {changed?, [result | rest]}
  #   end
  # end

  # defp recurse_change({changed?, left}, [], _opts) do
  #   {changed?, left}
  # end

  # defp recurse_change({changed?, left}, [head | tail], opts) do
  #   {changed?, result} = recurse_change({changed?, left}, head, opts)

  #   halt_on_change? = opts[:on_change] === :halt

  #   if changed? and halt_on_change? do
  #     {changed?, result}
  #   else
  #     recurse_change({changed?, result}, tail, opts)
  #   end
  # end

  # defp recurse_change({changed?, left}, {right, map}, opts) when is_map(map) and not is_struct(map) do
  #   recurse_change(
  #     {changed?, left},
  #     {right, Map.to_list(map)},
  #     opts
  #   )
  # end

  # defp recurse_change({changed?, left}, {_right, []}, _opts) do
  #   {changed?, left}
  # end

  # defp recurse_change({changed?, left}, {right, [head | tail]}, opts) do
  #   {changed?, result} = recurse_change({changed?, left}, {right, head}, opts)

  #   halt_on_change? = opts[:on_change] === :halt

  #   if changed? and halt_on_change? do
  #     {changed?, result}
  #   else
  #     recurse_change({changed?, result}, {right, tail}, opts)
  #   end
  # end

  # defp recurse_change({previous_change?, map}, {key, arg}, opts) when is_map(map) and not is_struct(map) do
  #   require IEx; IEx.pry()

  #   left = Map.get(map, key)

  #   {changed?, result} = change(left, arg, opts)

  #   {previous_change? || changed?, Map.put(map, key, result)}
  # end

  # defp recurse_change({change?, {existing_key, left}}, {key, arg}, opts) do
  #   if existing_key === key do
  #     {change?, result} = recurse_change({change?, left}, arg, opts)

  #     {change?, {existing_key, result}}
  #   else
  #     {change?, {existing_key, left}}
  #   end
  # end

  # defp recurse_change(
  #   {_changed?, left},
  #   {right, {operator, replacement}},
  #   opts
  # ) do
  #   if operator === :* do
  #     {true, replace(replacement, left, operator, right)}
  #   else
  #     operator = opts[:operator] || operator
  #     replacement = opts[:replacement] || replacement

  #     change(left, operator, right, replacement)
  #   end
  # end

  # defp recurse_change({changed?, left}, {right, replacement}, opts) do
  #   recurse_change(
  #     {changed?, left},
  #     {right, {:===, replacement}},
  #     opts
  #   )
  # end

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

  # defp replace(replacement, left) when is_function(replacement, 1) do
  #   replacement.(left)
  # end

  # defp replace(replacement, _left) when is_function(replacement, 0) do
  #   replacement.()
  # end

  # defp replace(replacement, _left) do
  #   replacement
  # end
end
