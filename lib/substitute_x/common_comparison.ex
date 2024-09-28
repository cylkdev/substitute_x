defmodule SubstituteX.CommonComparison do
  @moduledoc """
  A `SubstituteX.Engine` adapter.

  The following operations are supported:

    * `:===` - Evaluates if the `left` is equal to the `right`.

    * `:===` - Evaluates if the `left` does not equal `right`.

    * `:<` - Evaluates if the `left` is less than the `right`.

    * `:>` - Evaluates if the `left` is greater than the `right`.

    * `:<=` - Evaluates if `left` is less than or equal to `right`.

    * `:>=` - Evaluates if `left` is greater than or equal to `right`.

    * `:=~` - Text-based match operator. Matches the `left` against
      the regular expression or string on the `right`.

    * `:eq` - Same as `:===`.

    * `:lt` - Same as `:<`.

    * `:gt` - Same as `:>`.

    * `:lte` - Same as `:<=`.

    * `:gte` - Same as `:>=`.

    * `is_atom` - Returns `true` if `term` is an `atom`, otherwise returns `false`.

    * `is_boolean` - Returns `true` if `term` is a `boolean`, otherwise returns `false`.

    * `is_binary` - Returns `true` if `term` is a `string`, otherwise returns `false`.

    * `is_bitstring` - Returns `true` if `term` is a `bitstring`, otherwise returns `false`.

    * `is_exception` - Returns `true` if `term` is an `exception` of `name`, otherwise returns `false`.

    * `is_float` - Returns `true` if `term` is a `float`, otherwise returns `false`.

    * `is_function` - Returns `true` if `term` is a `function` that can be applied with `arity` number of arguments; otherwise returns false.

    * `is_integer` - Returns `true` if `term` is an `integer`, otherwise returns `false`.

    * `is_list` - Returns `true` if `term` is a `list`, otherwise returns `false`.

    * `is_map` - Returns `true` if `term` is a `map`, otherwise returns `false`.

    * `is_map_key` - Returns `true` if `key` is a `key` in a `map`, otherwise returns `false`.

    * `is_nil` - Returns `true` if `term` is `nil`, otherwise returns `false`.

    * `is_non_struct_map` - Returns `true` if `term` is a `map` that is not a `struct`, otherwise returns `false`.

    * `is_number` - Returns `true` if `term` is a `number`, otherwise returns `false`.

    * `is_pid` - Returns `true` if `term` is a `pid`, otherwise returns `false`.

    * `is_port` - Returns `true` if `term` is a `port`, otherwise returns `false`.

    * `is_reference` - Returns `true` if `term` is a `reference`, otherwise returns `false`.

    * `is_struct` - Returns `true` if `term` is a `struct`, otherwise returns `false`.

    * `is_tuple` - Returns `true` if `term` is a `tuple`, otherwise returns `false`.


  ### DateTime / NaiveDateTime / Decimal

  `DateTime`, `NaiveDateTime`, and `Decimal` structs are
  special cases that are compared with their respective
  `compare/2` functions when an operator is specified.
  """
  alias SubstituteX.Engine

  @behaviour SubstituteX.Engine

  @guard_operators [
    :is_atom,
    :is_boolean,
    :is_binary,
    :is_bitstring,
    :is_exception,
    :is_float,
    :is_function,
    :is_integer,
    :is_list,
    :is_map,
    :is_map_key,
    :is_nil,
    :is_non_struct_map,
    :is_number,
    :is_pid,
    :is_port,
    :is_reference,
    :is_struct,
    :is_tuple
  ]

  @common_operators [
    :===,
    :!==,
    :<,
    :>,
    :<=,
    :>=,
    :=~,
    :eq,
    :lt,
    :gt,
    :lte,
    :gte
  ]

  @operators @common_operators ++ @guard_operators

  @impl Engine
  @doc """
  Returns a list of supported operators.

  See the `SubstituteX.CommonComparison` module documentation
  for the complete list of supported operators.

  ### Examples

      iex> SubstituteX.CommonComparison.operators()
  """
  @spec operators :: list()
  def operators, do: @operators

  @impl Engine
  @doc """
  Returns `true` if the `operator` is supported.

  See the `SubstituteX.CommonComparison` module documentation
  for the complete list of supported operators.

  ### Examples

      iex> SubstituteX.CommonComparison.operator?(:===)
      true
  """
  @spec operator?(operator :: any()) :: true | false
  for operator <- @operators do
    def operator?(unquote(operator)), do: true
  end

  def operator?(_), do: false

  @impl Engine
  @doc """
  Returns `true` if the evaluation of the expression `<left> <operator> <right>`
  (e.g `1 === 1`) is `true`, otherwise `false`.

  See the `SubstituteX.CommonComparison` module documentation
  for the complete list of supported operators.

  ### Examples

      iex> SubstituteX.CommonComparison.evaluate?(1, :===, 1)
      true
  """
  @spec evaluate?(left :: any(), operator :: any(), right :: any()) :: boolean()
  def evaluate?(left, :is_atom, _right), do: is_atom(left)

  def evaluate?(left, :is_boolean, _right), do: is_boolean(left)

  def evaluate?(left, :is_binary, _right), do: is_binary(left)

  def evaluate?(left, :is_bitstring, _right), do: is_bitstring(left)

  def evaluate?(left, :is_exception, nil), do: is_exception(left)

  def evaluate?(left, :is_exception, right), do: is_exception(left, right)

  def evaluate?(left, :is_float, _right), do: is_float(left)

  def evaluate?(left, :is_function, nil), do: is_function(left)

  def evaluate?(left, :is_function, right), do: is_function(left, right)

  def evaluate?(left, :is_integer, _right), do: is_integer(left)

  def evaluate?(left, :is_list, _right), do: is_list(left)

  def evaluate?(left, :is_map, _right), do: is_map(left)

  def evaluate?(left, :is_map_key, right), do: is_map_key(left, right)

  def evaluate?(left, :is_nil, _right), do: is_nil(left)

  def evaluate?(left, :is_non_struct_map, _right), do: is_map(left) and (not is_struct(left))

  def evaluate?(left, :is_number, _right), do: is_number(left)

  def evaluate?(left, :is_pid, _right), do: is_pid(left)

  def evaluate?(left, :is_port, _right), do: is_port(left)

  def evaluate?(left, :is_reference, _right), do: is_reference(left)

  def evaluate?(left, :is_struct, right), do: is_struct(left, right)

  def evaluate?(left, :is_tuple, _right), do: is_tuple(left)

  def evaluate?(%DateTime{} = left, :===, %DateTime{} = right) do
    DateTime.compare(left, right) === :eq
  end

  def evaluate?(%DateTime{} = left, :!==, %DateTime{} = right) do
    DateTime.compare(left, right) !== :eq
  end

  def evaluate?(%DateTime{} = left, :<, %DateTime{} = right) do
    DateTime.compare(left, right) === :lt
  end

  def evaluate?(%DateTime{} = left, :>, %DateTime{} = right) do
    DateTime.compare(left, right) === :gt
  end

  def evaluate?(%DateTime{} = left, :<=, %DateTime{} = right) do
    evaluate?(left, :<, right) || evaluate?(left, :===, right)
  end

  def evaluate?(%DateTime{} = left, :>=, %DateTime{} = right) do
    evaluate?(left, :>, right) || evaluate?(left, :===, right)
  end

  def evaluate?(%DateTime{} = left, :eq, %DateTime{} = right) do
    evaluate?(left, :===, right)
  end

  def evaluate?(%DateTime{} = left, :lt, %DateTime{} = right) do
    evaluate?(left, :<, right)
  end

  def evaluate?(%DateTime{} = left, :gt, %DateTime{} = right) do
    evaluate?(left, :>, right)
  end

  def evaluate?(%DateTime{} = left, :lte, %DateTime{} = right) do
    evaluate?(left, :<=, right)
  end

  def evaluate?(%DateTime{} = left, :gte, %DateTime{} = right) do
    evaluate?(left, :>=, right)
  end

  def evaluate?(%NaiveDateTime{} = left, :===, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) === :eq
  end

  def evaluate?(%NaiveDateTime{} = left, :!==, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) !== :eq
  end

  def evaluate?(%NaiveDateTime{} = left, :<, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) === :lt
  end

  def evaluate?(%NaiveDateTime{} = left, :>, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) === :gt
  end

  def evaluate?(%NaiveDateTime{} = left, :<=, %NaiveDateTime{} = right) do
    evaluate?(left, :<, right) || evaluate?(left, :===, right)
  end

  def evaluate?(%NaiveDateTime{} = left, :>=, %NaiveDateTime{} = right) do
    evaluate?(left, :>, right) || evaluate?(left, :===, right)
  end

  def evaluate?(%NaiveDateTime{} = left, :eq, %NaiveDateTime{} = right) do
    evaluate?(left, :===, right)
  end

  def evaluate?(%NaiveDateTime{} = left, :lt, %NaiveDateTime{} = right) do
    evaluate?(left, :<, right)
  end

  def evaluate?(%NaiveDateTime{} = left, :gt, %NaiveDateTime{} = right) do
    evaluate?(left, :>, right)
  end

  def evaluate?(%NaiveDateTime{} = left, :lte, %NaiveDateTime{} = right) do
    evaluate?(left, :<=, right)
  end

  def evaluate?(%NaiveDateTime{} = left, :gte, %NaiveDateTime{} = right) do
    evaluate?(left, :>=, right)
  end

  if Code.ensure_loaded?(Decimal) do
    def evaluate?(%Decimal{} = left, :===, %Decimal{} = right) do
      Decimal.compare(left, right) === :eq
    end

    def evaluate?(%Decimal{} = left, :!==, %Decimal{} = right) do
      Decimal.compare(left, right) !== :eq
    end

    def evaluate?(%Decimal{} = left, :<, %Decimal{} = right) do
      Decimal.compare(left, right) === :lt
    end

    def evaluate?(%Decimal{} = left, :>, %Decimal{} = right) do
      Decimal.compare(left, right) === :gt
    end

    def evaluate?(%Decimal{} = left, :<=, %Decimal{} = right) do
      evaluate?(left, :<, right) || evaluate?(left, :===, right)
    end

    def evaluate?(%Decimal{} = left, :>=, %Decimal{} = right) do
      evaluate?(left, :>, right) || evaluate?(left, :===, right)
    end

    def evaluate?(%Decimal{} = left, :eq, %Decimal{} = right) do
      evaluate?(left, :===, right)
    end

    def evaluate?(%Decimal{} = left, :lt, %Decimal{} = right) do
      evaluate?(left, :<, right)
    end

    def evaluate?(%Decimal{} = left, :gt, %Decimal{} = right) do
      evaluate?(left, :>, right)
    end

    def evaluate?(%Decimal{} = left, :lte, %Decimal{} = right) do
      evaluate?(left, :<=, right)
    end

    def evaluate?(%Decimal{} = left, :gte, %Decimal{} = right) do
      evaluate?(left, :>=, right)
    end
  end

  def evaluate?(left, :===, right) do
    left === right
  end

  def evaluate?(left, :!==, right) do
    left !== right
  end

  def evaluate?(left, :=~, right) do
    left =~ right
  end

  def evaluate?(left, :<, right) do
    left < right
  end

  def evaluate?(left, :>, right) do
    left > right
  end

  def evaluate?(left, :<=, right) do
    left <= right
  end

  def evaluate?(left, :>=, right) do
    left >= right
  end

  def evaluate?(left, :eq, right) do
    evaluate?(left, :===, right)
  end

  def evaluate?(left, :lt, right) do
    evaluate?(left, :<, right)
  end

  def evaluate?(left, :gt, right) do
    evaluate?(left, :>, right)
  end

  def evaluate?(left, :lte, right) do
    evaluate?(left, :<=, right)
  end

  def evaluate?(left, :gte, right) do
    evaluate?(left, :>=, right)
  end
end
