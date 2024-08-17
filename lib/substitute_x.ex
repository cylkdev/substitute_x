defmodule SubstituteX do
  @moduledoc File.read!("README.md")

  alias SubstituteX.{Config, ComparisonEngine}

  @type change_response :: {true | false, term()}

  @behaviour SubstituteX.ComparisonEngine

  @doc """
  Returns true if `term` is a map and not a struct.
  """
  defguard is_not_struct_map(term) when is_map(term) and not is_struct(term)

  if Config.inline() do
    @compile {:inline, compare?: 3}
  end

  @impl true
  @doc """
  Implements `c:SubstituteX.ComparisonEngine.compare?/3`.

  Returns `true` if `left` compared to `right`
  by the given operator is `true`.

  * `:===` - Checks if `left` equals `right`.
    Uses `compare/2` for `DateTime` and `NaiveDateTime` structs.

  * `:<` - Checks if `left` is less than `right`.
    Uses `compare/2` for `DateTime` and `NaiveDateTime` structs.

  * `:>` - Checks if `left` is greater than `right`.
    Uses `compare/2` for `DateTime` and `NaiveDateTime` structs.

  * `:<=` - Checks if `left` is less than or equal to `right`.
    Uses `compare/2` for `DateTime` and `NaiveDateTime` structs.

  * `:>=` - Checks if `left` is greater than or equal to `right`.
    Uses `compare/2` for `DateTime` and `NaiveDateTime` structs.

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

      iex> SubstituteX.compare?(%{body: "foo"}, %{body: "foo"})
      true

      iex> SubstituteX.compare?(%{post: %{comments: [%{body: "foo"}]}}, %{post: %{comments: %{body: "foo"}}})
      true
  """
  def compare?(left, schema) when is_map(schema) do
    compare?(left, Map.to_list(schema))
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

  defp recurse_compare(list, arg) when is_list(list) do
    case list do
      [] -> false
      [left] -> recurse_compare(left, arg)
      [left | tail] -> recurse_compare(left, arg) and recurse_compare(tail, arg)
    end
  end

  defp recurse_compare(left, {key, map}) when is_not_struct_map(map) do
    recurse_compare(left, {key, Map.to_list(map)})
  end

  defp recurse_compare(left, {key, list}) when is_list(list) do
    case list do
      [] -> true
      [right] -> recurse_compare(left, {key, right})
      [head | tail] -> recurse_compare(left, {key, head}) and recurse_compare(left, {key, tail})
    end
  end

  defp recurse_compare(left, list) when is_list(list) do
    case list do
      [] -> true
      [right] -> recurse_compare(left, right)
      [head | tail] -> recurse_compare(left, head) and recurse_compare(left, tail)
    end
  end

  defp recurse_compare({field, left}, {key, right}) do
    with true <- field === key do
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
  ) :: change_response()
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
  ) :: change_response()
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

      iex> SubstituteX.change("foo", %{"foo" => %{===: "bar"}})
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

      iex> SubstituteX.change("foo", {"foo", "bar"})
      {true, "bar"}

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
    schema :: map(),
    opts :: keyword()
  ) :: change_response()
  def change(term, schema, opts) when is_map(schema) do
    schema = Map.to_list(schema)

    change(term, schema, opts)
  end

  @spec change(
    term :: term(),
    schema :: list(),
    opts :: keyword()
  ) :: change_response()
  def change(term, schema, opts) do
    opts = Keyword.put_new(opts, :on_change, :halt)

    transform({false, term}, schema, opts)
  end

  @spec change(term :: term(), schema :: map() | list()) :: change_response()
  def change(term, schema) do
    change(term, schema, [])
  end

  defp transform({changed?, left}, {schema, replacement}, _opts) do
    if compare?(left, schema) do
      {true, resolve(replacement, left)}
    else
      {changed?, left}
    end
  end

  defp transform(input, schema, opts) do
    recurse_change(input, schema, opts)
  end

  defp recurse_change({changed?, left}, list, opts) when is_list(list) do
    case list do
      [] ->
        {changed?, left}

      [head] ->
        recurse_change({changed?, left}, head, opts)

      [head | tail] ->
        {changed?, result} = recurse_change({changed?, left}, head, opts)

        halt_on_change? = opts[:on_change] === :halt

        if changed? and halt_on_change? do
          {changed?, result}
        else
          recurse_change({changed?, result}, tail, opts)
        end
    end
  end

  defp recurse_change({changed?, left}, {right, list}, opts) when is_list(list) do
    case list do
      [] ->
        {changed?, left}

      [head] ->
        recurse_change({changed?, left}, {right, head}, opts)

      [head | tail] ->
        {changed?, result} = recurse_change({changed?, left}, {right, head}, opts)

        halt_on_change? = opts[:on_change] === :halt

        if changed? and halt_on_change? do
          {changed?, result}
        else
          recurse_change({changed?, result}, {right, tail}, opts)
        end
    end
  end

  defp recurse_change(
    {changed?, left},
    {right, definitions},
    opts
  ) when is_not_struct_map(definitions) do
    recurse_change(
      {changed?, left},
      {right, Map.to_list(definitions)},
      opts
    )
  end

  defp recurse_change(
    {changed?, map},
    {key, {right, operator_replacements}},
    opts
  ) when is_not_struct_map(map) do
    case Map.get(map, key) do
      nil ->
        {changed?, map}

      left ->
        {changed?, result} =
          recurse_change(
            {false, left},
            {right, operator_replacements},
            opts
          )

        {changed?, Map.put(map, key, result)}
    end
  end

  defp recurse_change(
    {change?, {field, left}},
    {key, {right, operator_replacements}},
    opts
  ) do
    if field === key do
      {change?, result} =
        recurse_change(
          {change?, left},
          {right, operator_replacements},
          opts
        )

      {change?, {field, result}}
    else
      {change?, {field, left}}
    end
  end

  defp recurse_change(
    {previous_change?, list},
    {key, {right, operator_replacements}},
    opts
  ) when is_list(list) do
    {changed?, results} =
      Enum.reduce(
        list,
        {previous_change?, []},
        fn left, {previous_change?, acc} ->
          {changed?, result} =
            recurse_change(
              {false, left},
              {key, {right, operator_replacements}},
              opts
            )

          {previous_change? || changed?, [result | acc]}
        end
      )

    {changed?, Enum.reverse(results)}
  end

  defp recurse_change(
    {_changed?, left},
    {right, {operator, replacement}},
    _opts
  ) do
    if operator === :* do
      {true, resolve(replacement, left, operator, right)}
    else
      change(left, operator, right, replacement)
    end
  end

  defp recurse_change(
    {_changed?, left},
    {right, replacement},
    _opts
  ) do
    change(left, :===, right, replacement)
  end

  defp resolve(replacement, left) do
    cond do
      is_function(replacement, 1) -> replacement.(left)
      is_function(replacement) -> replacement.()
      true -> replacement
    end
  end

  defp resolve(replacement, left, operator, right) do
    cond do
      is_function(replacement, 3) -> replacement.(left, operator, right)
      is_function(replacement, 2) -> replacement.(left, operator)
      is_function(replacement, 1) -> replacement.(left)
      is_function(replacement) -> replacement.()
      true -> replacement
    end
  end
end
