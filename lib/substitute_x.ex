defmodule SubstituteX do
  @moduledoc File.read!("README.md")

  alias SubstituteX.ComparisonEngine

  @behaviour SubstituteX.ComparisonEngine

  @impl true
  @doc """
  Implements `c:SubstituteX.ComparisonEngine.compare?/3`.

  Returns `true` if `left` compared to `right`
  by the given operator is `true`.

  * `:===` - Checks if `left` equals `right`.
    Uses `compare/2` for `DateTime`, `NaiveDateTime`, and `Decimal` structs.

  * `:<` - Checks if `left` is less than `right`.
    Uses `compare/2` for `DateTime`, `NaiveDateTime`, and `Decimal` structs.

  * `:>` - Checks if `left` is greater than `right`.
    Uses `compare/2` for `DateTime`, `NaiveDateTime`, and `Decimal` structs.

  * `:<=` - Checks if `left` is less than or equal to `right`.
    Uses `compare/2` for `DateTime`, `NaiveDateTime`, and `Decimal` structs.

  * `:>=` - Checks if `left` is greater than or equal to `right`.
    Uses `compare/2` for `DateTime`, `NaiveDateTime`, and `Decimal` structs.

  * `:=~` - Matches `left` against regex or string on `right`.

  * `:eq` - Same as `:===`.

  * `:lt` - Same as `:<`.

  * `:gt` - Same as `:>`.

  * `:lte` - Same as `:<=`.

  * `:gte` - Same as `:>=`.

  ### Examples

      # The term on the left equals the term on the right
      iex> SubstituteX.compare?(1, :===, 1)
      true
  """
  @spec compare?(left :: term(), operator :: term(), right :: term()) :: boolean()
  def compare?(%DateTime{} = left, :===, %DateTime{} = right) do
    DateTime.compare(left, right) === :eq
  end

  def compare?(%DateTime{} = left, :<, %DateTime{} = right) do
    DateTime.compare(left, right) === :lt
  end

  def compare?(%DateTime{} = left, :>, %DateTime{} = right) do
    DateTime.compare(left, right) === :gt
  end

  def compare?(%DateTime{} = left, :<=, %DateTime{} = right) do
    compare?(left, :<, right) || compare?(left, :===, right)
  end

  def compare?(%DateTime{} = left, :>=, %DateTime{} = right) do
    compare?(left, :>, right) || compare?(left, :===, right)
  end

  def compare?(%DateTime{} = left, :eq, %DateTime{} = right) do
    compare?(left, :===, right)
  end

  def compare?(%DateTime{} = left, :lt, %DateTime{} = right) do
    compare?(left, :<, right)
  end

  def compare?(%DateTime{} = left, :gt, %DateTime{} = right) do
    compare?(left, :>, right)
  end

  def compare?(%DateTime{} = left, :lte, %DateTime{} = right) do
    compare?(left, :<=, right)
  end

  def compare?(%DateTime{} = left, :gte, %DateTime{} = right) do
    compare?(left, :>=, right)
  end

  def compare?(%NaiveDateTime{} = left, :===, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) === :eq
  end

  def compare?(%NaiveDateTime{} = left, :<, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) === :lt
  end

  def compare?(%NaiveDateTime{} = left, :>, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) === :gt
  end

  def compare?(%NaiveDateTime{} = left, :<=, %NaiveDateTime{} = right) do
    compare?(left, :<, right) || compare?(left, :===, right)
  end

  def compare?(%NaiveDateTime{} = left, :>=, %NaiveDateTime{} = right) do
    compare?(left, :>, right) || compare?(left, :===, right)
  end

  def compare?(%NaiveDateTime{} = left, :eq, %NaiveDateTime{} = right) do
    compare?(left, :===, right)
  end

  def compare?(%NaiveDateTime{} = left, :lt, %NaiveDateTime{} = right) do
    compare?(left, :<, right)
  end

  def compare?(%NaiveDateTime{} = left, :gt, %NaiveDateTime{} = right) do
    compare?(left, :>, right)
  end

  def compare?(%NaiveDateTime{} = left, :lte, %NaiveDateTime{} = right) do
    compare?(left, :<=, right)
  end

  def compare?(%NaiveDateTime{} = left, :gte, %NaiveDateTime{} = right) do
    compare?(left, :>=, right)
  end

  if Code.ensure_loaded?(Decimal) do
    def compare?(%Decimal{} = left, :===, %Decimal{} = right) do
      Decimal.compare(left, right) === :eq
    end

    def compare?(%Decimal{} = left, :<, %Decimal{} = right) do
      Decimal.compare(left, right) === :lt
    end

    def compare?(%Decimal{} = left, :>, %Decimal{} = right) do
      Decimal.compare(left, right) === :gt
    end

    def compare?(%Decimal{} = left, :<=, %Decimal{} = right) do
      compare?(left, :<, right) || compare?(left, :===, right)
    end

    def compare?(%Decimal{} = left, :>=, %Decimal{} = right) do
      compare?(left, :>, right) || compare?(left, :===, right)
    end

    def compare?(%Decimal{} = left, :eq, %Decimal{} = right) do
      compare?(left, :===, right)
    end

    def compare?(%Decimal{} = left, :lt, %Decimal{} = right) do
      compare?(left, :<, right)
    end

    def compare?(%Decimal{} = left, :gt, %Decimal{} = right) do
      compare?(left, :>, right)
    end

    def compare?(%Decimal{} = left, :lte, %Decimal{} = right) do
      compare?(left, :<=, right)
    end

    def compare?(%Decimal{} = left, :gte, %Decimal{} = right) do
      compare?(left, :>=, right)
    end
  end

  def compare?(left, :===, right) do
    left === right
  end

  def compare?(left, :=~, right) do
    left =~ right
  end

  def compare?(left, :<, right) do
    left < right
  end

  def compare?(left, :>, right) do
    left > right
  end

  def compare?(left, :<=, right) do
    left <= right
  end

  def compare?(left, :>=, right) do
    left >= right
  end

  def compare?(left, :eq, right) do
    compare?(left, :===, right)
  end

  def compare?(left, :lt, right) do
    compare?(left, :<, right)
  end

  def compare?(left, :gt, right) do
    compare?(left, :>, right)
  end

  def compare?(left, :lte, right) do
    compare?(left, :<=, right)
  end

  def compare?(left, :gte, right) do
    compare?(left, :>=, right)
  end

  @doc """
  Returns true if the schema matches the entire term on the left

  ### Examples

      iex> SubstituteX.compare?("foo", "foo")
      true

      iex> SubstituteX.compare?({"foo"}, "foo")
      true

      iex> SubstituteX.compare?(%{body: "foo"}, %{body: "foo"})
      true

      iex> SubstituteX.compare?(%{post: %{comments: [%{body: "foo"}]}}, %{post: %{comments: %{body: "foo"}}})
      true
  """
  def compare?(left, schema) when is_map(schema) do
    compare?(left, Map.to_list(schema))
  end

  def compare?(left, schema) when is_tuple(left) do
    left
    |> Tuple.to_list()
    |> compare?(schema)
  end

  def compare?(left, schema) do
    recurse_compare(left, schema)
  end

  defp recurse_compare(_left, :*) do
    true
  end

  defp recurse_compare(map, arg) when is_map(map) do
    map
    |> Map.to_list()
    |> recurse_compare(arg)
  end

  defp recurse_compare([], _arg) do
    false
  end

  defp recurse_compare([last], arg) do
    recurse_compare(last, arg)
  end

  defp recurse_compare([head | tail], arg) do
    recurse_compare(head, arg) and recurse_compare(tail, arg)
  end

  defp recurse_compare(_left, []) do
    true
  end

  defp recurse_compare(left, [last]) do
    recurse_compare(left, last)
  end

  defp recurse_compare(left, [head | tail]) do
    recurse_compare(left, head) and recurse_compare(left, tail)
  end

  defp recurse_compare(left, {key, map}) when is_map(map) and not is_struct(map) do
    recurse_compare(left, {key, Map.to_list(map)})
  end

  defp recurse_compare(_left, {_key, []}) do
    true
  end

  defp recurse_compare(left, {key, [last]}) do
    recurse_compare(left, {key, last})
  end

  defp recurse_compare(left, {key, [head | tail]}) do
    recurse_compare(left, {key, head}) and recurse_compare(left, {key, tail})
  end

  defp recurse_compare({existing_key, left}, {key, right}) do
    with true <- existing_key === key do
      recurse_compare(left, right)
    end
  end

  defp recurse_compare(left, {operator, right}) do
    compare?(left, operator, right)
  end

  defp recurse_compare(left, pattern) do
    compare?(left, :===, pattern)
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
      {true, "goodbye"}

      iex> SubstituteX.change("hello", :===, "not_a_match", "no_change_will_be_made")
      {false, "hello"}

      iex> SubstituteX.change("hello", :===, "hello", fn string, _operator, _right -> string <> " world!" end)
      {true, "hello world!"}

      iex> SubstituteX.change("hello", :===, "hello", fn string -> string <> " world!" end)
      {true, "hello world!"}

      iex> SubstituteX.change("hello", :===, "hello", fn -> "goodbye" end)
      {true, "goodbye"}
  """
  @spec change(
    left :: term(),
    operator :: term(),
    right :: term(),
    replacement :: function() | term(),
    opts :: keyword()
  ) :: {true | false, term()}
  def change(left, operator, right, replacement, opts) do
    if ComparisonEngine.compare?(left, operator, right, opts) do
      {true, resolve(replacement, left, operator, right)}
    else
      {false, left}
    end
  end

  @spec change(
    left :: term(),
    operator :: term(),
    right :: term(),
    replacement :: function() | term()
  ) :: {true | false, term()}
  def change(left, operator, right, replacement) do
    change(left, operator, right, replacement, [])
  end

  @doc """
  A simple wrapper for the `change/4` function that returns
  only the value, without the status tuple. This is useful
  when you want to change a value and don't need to know
  if the value was altered.

  ### Examples

      iex> SubstituteX.change!("hello", :===, "hello", "goodbye")
      "goodbye"

      iex> SubstituteX.change!("hello", :===, "not_a_match", "no_change_will_be_made")
      "hello"

      iex> SubstituteX.change!("hello", :===, "hello", fn string, _operator, _right -> string <> " world!" end)
      "hello world!"

      iex> SubstituteX.change!("hello", :===, "hello", fn string -> string <> " world!" end)
      "hello world!"

      iex> SubstituteX.change!("hello", :===, "hello", fn -> "goodbye" end)
      "goodbye"
  """
  @spec change!(
    left :: term(),
    operator :: term(),
    right :: term(),
    replacement :: function() | term(),
    opts :: keyword()
  ) :: term()
  def change!(left, operator, right, replacement, opts) do
    {_changed?, value} = change(left, operator, right, replacement, opts)

    value
  end

  @spec change!(
    left :: term(),
    operator :: term(),
    right :: term(),
    replacement :: function() | term()
  ) :: term()
  def change!(left, operator, right, replacement) do
    change!(left, operator, right, replacement, [])
  end

  @doc """
  A simple wrapper for the `change/3` function that returns
  only the value, without the status tuple. This is useful
  when you want to change a value and don't need to know
  if the value was altered.

  ### Examples

      iex> SubstituteX.change!("foo", %{"foo" => "bar"})
      "bar"
  """
  @spec change!(
    term :: term(),
    schema :: term(),
    opts :: keyword()
  ) :: term()
  def change!(term, schema, opts) do
    {_changed?, result} = change(term, schema, opts)

    result
  end

  @spec change!(
    term :: term(),
    schema :: term()
  ) :: term()
  def change!(term, schema) do
    change!(term, schema, [])
  end

  @doc """
  Transforms a term by schema.

  ### Options

    * `:on_change` - Defines the function's behavior the
      first time a value is changed. When set to `:halt`,
      the function immediately returns the result of the
      change function. If not set to `:halt`, changes
      are applied in sequence.

  ### Examples

      iex> SubstituteX.change("foo", %{"foo" => "bar"})
      {true, "bar"}

      iex> SubstituteX.change("foo", [%{"qux" => "bux"}, %{"foo" => "bar"}])
      {true, "bar"}

      iex> SubstituteX.change("foo", %{"foo" => %{===: "bar"}})
      {true, "bar"}

      iex> SubstituteX.change({"bar", "foo"}, %{"foo" => "qux"})
      {true, {"bar", "qux"}}

      iex> SubstituteX.change("foo", {"foo", "bar"})
      {true, "bar"}

      iex> SubstituteX.change("foo", [{"qux", "bux"}, {"foo", "bar"}])
      {true, "bar"}

      iex> SubstituteX.change(%{body: "foo"}, %{body: %{"foo" => "bar"}})
      {true, %{body: "bar"}}

      iex> SubstituteX.change(%{post: %{comments: [%{body: "foo"}, %{body: "bar"}]}}, %{post: %{comments: %{body: %{"foo" => "qux"}}}})
      {true, %{post: %{comments: [%{body: "qux"}, %{body: "bar"}]}}}

      iex> SubstituteX.change(%{body: "foo"}, %{body: %{"foo" => %{===: "bar"}}})
      {true, %{body: "bar"}}

      iex> SubstituteX.change([body: "foo"], %{body: %{"foo" => "bar"}})
      {true, [body: "bar"]}

      iex> SubstituteX.change([body: "foo"], %{body: %{"foo" => %{===: "bar"}}})
      {true, [body: "bar"]}

      iex> SubstituteX.change([post: [comments: [%{body: "foo"}, %{body: "bar"}]]], %{post: %{comments: %{body: %{"foo" => "qux"}}}})
      {true, [post: [comments: [%{body: "qux"}, %{body: "bar"}]]]}

      iex> SubstituteX.change(%{body: "foo"}, {%{body: "foo"}, %{body: "bar"}})
      {true, %{body: "bar"}}

      iex> SubstituteX.change(%{body: "foo"}, {%{body: "foo"}, fn -> %{body: "bar"} end})
      {true, %{body: "bar"}}

      iex> SubstituteX.change(%{body: "foo"}, {%{body: "foo"}, fn %{body: "foo"} -> %{body: "bar"} end})
      {true, %{body: "bar"}}

      iex> SubstituteX.change(
      ...>   %{post: %{comments: [%{body: "foo"}, %{body: "bar"}]}},
      ...>   {
      ...>     %{post: %{comments: %{body: %{=~: ~r|.*|}}}},
      ...>     fn -> %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}} end
      ...>   }
      ...> )
      {true, %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}}}

      iex> SubstituteX.change(
      ...>   %{post: %{comments: [%{body: "foo"}, %{body: "bar"}]}},
      ...>   {
      ...>     %{post: %{comments: %{body: :*}}},
      ...>     fn -> %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}} end
      ...>   }
      ...> )
      {true, %{post: %{comments: [%{body: "qux"}, %{body: "bux"}]}}}
  """
  @spec change(
    term :: term(),
    schema :: term(),
    opts :: keyword()
  ) :: {true | false, term()}
  def change(term, schema, opts) when is_map(schema) do
    schema = Map.to_list(schema)

    change(term, schema, opts)
  end

  def change(term, {schema, replacement}, _opts) do
    if compare?(term, schema) do
      {true, resolve(replacement, term)}
    else
      {false, term}
    end
  end

  def change(term, [head | _tail] = schemas, opts) when is_map(head) or is_list(head) do
    Enum.reduce_while(schemas, {false, term}, fn head, {previous_change?, term} ->
      {changed?, result} = change(term, head, opts)

      halt_on_change? = opts[:on_change] === :halt

      signal = if changed? and halt_on_change?, do: :halt, else: :cont

      {signal, {previous_change? || changed?, result}}
    end)
  end

  def change(tuple, schema, opts) when is_tuple(tuple) do
    with {changed?, result} <- tuple |> Tuple.to_list() |> change(schema, opts) do
      {changed?, List.to_tuple(result)}
    end
  end

  def change(term, schema, opts) do
    opts = Keyword.put_new(opts, :on_change, :halt)

    recurse_change({false, term}, schema, opts)
  end

  def change(term, schema) do
    change(term, schema, [])
  end

  defp recurse_change({changed?, []}, _arg, _opts) do
    {changed?, []}
  end

  defp recurse_change({changed?, [head | tail]}, arg, opts) do
    {changed?, result} = recurse_change({changed?, head}, arg, opts)

    halt_on_change? = opts[:on_change] === :halt

    if changed? and halt_on_change? do
      {changed?, [result | tail]}
    else
      {changed?, rest} = recurse_change({changed?, tail}, arg, opts)

      {changed?, [result | rest]}
    end
  end

  defp recurse_change({changed?, term}, [], _opts) do
    {changed?, term}
  end

  defp recurse_change({changed?, term}, [head | tail], opts) do
    {changed?, result} = recurse_change({changed?, term}, head, opts)

    halt_on_change? = opts[:on_change] === :halt

    if changed? and halt_on_change? do
      {changed?, result}
    else
      recurse_change({changed?, result}, tail, opts)
    end
  end

  defp recurse_change({changed?, term}, {right, map}, opts)
    when is_map(map) and not is_struct(map) do
    recurse_change(
      {changed?, term},
      {right, Map.to_list(map)},
      opts
    )
  end

  defp recurse_change({changed?, term}, {_right, []}, _opts) do
    {changed?, term}
  end

  defp recurse_change({changed?, term}, {right, [head | tail]}, opts) do
    {changed?, result} = recurse_change({changed?, term}, {right, head}, opts)

    halt_on_change? = opts[:on_change] === :halt

    if changed? and halt_on_change? do
      {changed?, result}
    else
      recurse_change({changed?, result}, {right, tail}, opts)
    end
  end

  defp recurse_change({changed?, map}, {key, arg}, opts) when is_map(map) and not is_struct(map) do
    case Map.get(map, key) do
      nil ->
        {changed?, map}

      term ->
        {changed?, result} = recurse_change({false, term}, arg, opts)

        {changed?, Map.put(map, key, result)}
    end
  end

  defp recurse_change({change?, {existing_key, term}}, {key, arg}, opts) do
    if existing_key === key do
      {change?, result} = recurse_change({change?, term}, arg, opts)

      {change?, {existing_key, result}}
    else
      {change?, {existing_key, term}}
    end
  end

  defp recurse_change(
    {_changed?, term},
    {right, {operator, replacement}},
    opts
  ) do
    if operator === :* do
      {true, resolve(replacement, term, operator, right)}
    else
      operator = opts[:operator] || operator
      replacement = opts[:replacement] || replacement

      change(term, operator, right, replacement)
    end
  end

  defp recurse_change({changed?, term}, {right, replacement}, opts) do
    recurse_change(
      {changed?, term},
      {right, {:===, replacement}},
      opts
    )
  end

  defp resolve(replacement, term) do
    cond do
      is_function(replacement, 1) -> replacement.(term)
      is_function(replacement) -> replacement.()
      true -> replacement
    end
  end

  defp resolve(replacement, term, operator, right) do
    cond do
      is_function(replacement, 3) -> replacement.(term, operator, right)
      is_function(replacement, 2) -> replacement.(term, operator)
      is_function(replacement, 1) -> replacement.(term)
      is_function(replacement) -> replacement.()
      true -> replacement
    end
  end
end
