defmodule SubstituteX.CommonComparison do
  @moduledoc """
  A `SubstituteX.ComparisonEngine` adapter.
  """
  alias SubstituteX.ComparisonEngine

  @behaviour ComparisonEngine

  @operators ~w(=== !== < > <= >= =~ eq lt gt lte gte)a

  @impl ComparisonEngine
  @doc """
  Returns a list of supported operators.

  ### Examples

      iex> SubstituteX.CommonComparison.operators()
      [:===, :!==, :<, :>, :<=, :>=, :=~, :eq, :lt, :gt, :lte, :gte]
  """
  @spec operators :: list()
  def operators, do: @operators

  @impl ComparisonEngine
  @doc """
  Returns `true` if the `operator` is supported.

  The following operators are supported:

    * `:===`
    * `:!==`
    * `:<`
    * `:>`
    * `:<=`
    * `:>=`
    * `:=~`
    * `:eq`
    * `:lt`
    * `:gt`
    * `:lte`
    * `:gte`

  ### Examples

      iex> SubstituteX.CommonComparison.operator?(:===)
      true

      iex> SubstituteX.CommonComparison.operator?(:!==)
      true

      iex> SubstituteX.CommonComparison.operator?(:<)
      true

      iex> SubstituteX.CommonComparison.operator?(:>)
      true

      iex> SubstituteX.CommonComparison.operator?(:<=)
      true

      iex> SubstituteX.CommonComparison.operator?(:>=)
      true

      iex> SubstituteX.CommonComparison.operator?(:=~)
      true

      iex> SubstituteX.CommonComparison.operator?(:eq)
      true

      iex> SubstituteX.CommonComparison.operator?(:lt)
      true

      iex> SubstituteX.CommonComparison.operator?(:gt)
      true

      iex> SubstituteX.CommonComparison.operator?(:lte)
      true

      iex> SubstituteX.CommonComparison.operator?(:gte)
      true

      iex> SubstituteX.CommonComparison.operator?(:invalid)
      false
  """
  @spec operator?(operator :: atom()) :: true | false
  def operator?(:!==), do: true
  def operator?(:===), do: true
  def operator?(:<), do: true
  def operator?(:>), do: true
  def operator?(:<=), do: true
  def operator?(:>=), do: true
  def operator?(:=~), do: true
  def operator?(:eq), do: true
  def operator?(:lt), do: true
  def operator?(:gt), do: true
  def operator?(:lte), do: true
  def operator?(:gte), do: true
  def operator?(_), do: false

  @impl ComparisonEngine
  @doc """
  Returns `true` if `left` compared to `right` by the given operator is `true`.

  The following operations are supported:

    * `:===` - Checks if `left` equal `right`.
      Uses `compare/2` for `DateTime`, `NaiveDateTime`, and `Decimal` structs.

      * `:===` - Checks if `left` does not equal `right`.
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

      iex> SubstituteX.CommonComparison.matches?(1, :===, 1)
      true
  """
  @spec matches?(left :: any(), operator :: any(), right :: any()) :: boolean()
  def matches?(%DateTime{} = left, :===, %DateTime{} = right) do
    DateTime.compare(left, right) === :eq
  end

  def matches?(%DateTime{} = left, :!==, %DateTime{} = right) do
    DateTime.compare(left, right) !== :eq
  end

  def matches?(%DateTime{} = left, :<, %DateTime{} = right) do
    DateTime.compare(left, right) === :lt
  end

  def matches?(%DateTime{} = left, :>, %DateTime{} = right) do
    DateTime.compare(left, right) === :gt
  end

  def matches?(%DateTime{} = left, :<=, %DateTime{} = right) do
    matches?(left, :<, right) || matches?(left, :===, right)
  end

  def matches?(%DateTime{} = left, :>=, %DateTime{} = right) do
    matches?(left, :>, right) || matches?(left, :===, right)
  end

  def matches?(%DateTime{} = left, :eq, %DateTime{} = right) do
    matches?(left, :===, right)
  end

  def matches?(%DateTime{} = left, :lt, %DateTime{} = right) do
    matches?(left, :<, right)
  end

  def matches?(%DateTime{} = left, :gt, %DateTime{} = right) do
    matches?(left, :>, right)
  end

  def matches?(%DateTime{} = left, :lte, %DateTime{} = right) do
    matches?(left, :<=, right)
  end

  def matches?(%DateTime{} = left, :gte, %DateTime{} = right) do
    matches?(left, :>=, right)
  end

  def matches?(%NaiveDateTime{} = left, :===, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) === :eq
  end

  def matches?(%NaiveDateTime{} = left, :!==, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) !== :eq
  end

  def matches?(%NaiveDateTime{} = left, :<, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) === :lt
  end

  def matches?(%NaiveDateTime{} = left, :>, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right) === :gt
  end

  def matches?(%NaiveDateTime{} = left, :<=, %NaiveDateTime{} = right) do
    matches?(left, :<, right) || matches?(left, :===, right)
  end

  def matches?(%NaiveDateTime{} = left, :>=, %NaiveDateTime{} = right) do
    matches?(left, :>, right) || matches?(left, :===, right)
  end

  def matches?(%NaiveDateTime{} = left, :eq, %NaiveDateTime{} = right) do
    matches?(left, :===, right)
  end

  def matches?(%NaiveDateTime{} = left, :lt, %NaiveDateTime{} = right) do
    matches?(left, :<, right)
  end

  def matches?(%NaiveDateTime{} = left, :gt, %NaiveDateTime{} = right) do
    matches?(left, :>, right)
  end

  def matches?(%NaiveDateTime{} = left, :lte, %NaiveDateTime{} = right) do
    matches?(left, :<=, right)
  end

  def matches?(%NaiveDateTime{} = left, :gte, %NaiveDateTime{} = right) do
    matches?(left, :>=, right)
  end

  if Code.ensure_loaded?(Decimal) do
    def matches?(%Decimal{} = left, :===, %Decimal{} = right) do
      Decimal.compare(left, right) === :eq
    end

    def matches?(%Decimal{} = left, :!==, %Decimal{} = right) do
      Decimal.compare(left, right) !== :eq
    end

    def matches?(%Decimal{} = left, :<, %Decimal{} = right) do
      Decimal.compare(left, right) === :lt
    end

    def matches?(%Decimal{} = left, :>, %Decimal{} = right) do
      Decimal.compare(left, right) === :gt
    end

    def matches?(%Decimal{} = left, :<=, %Decimal{} = right) do
      matches?(left, :<, right) || matches?(left, :===, right)
    end

    def matches?(%Decimal{} = left, :>=, %Decimal{} = right) do
      matches?(left, :>, right) || matches?(left, :===, right)
    end

    def matches?(%Decimal{} = left, :eq, %Decimal{} = right) do
      matches?(left, :===, right)
    end

    def matches?(%Decimal{} = left, :lt, %Decimal{} = right) do
      matches?(left, :<, right)
    end

    def matches?(%Decimal{} = left, :gt, %Decimal{} = right) do
      matches?(left, :>, right)
    end

    def matches?(%Decimal{} = left, :lte, %Decimal{} = right) do
      matches?(left, :<=, right)
    end

    def matches?(%Decimal{} = left, :gte, %Decimal{} = right) do
      matches?(left, :>=, right)
    end
  end

  def matches?(left, :===, right) do
    left === right
  end

  def matches?(left, :!==, right) do
    left !== right
  end

  def matches?(left, :=~, right) do
    left =~ right
  end

  def matches?(left, :<, right) do
    left < right
  end

  def matches?(left, :>, right) do
    left > right
  end

  def matches?(left, :<=, right) do
    left <= right
  end

  def matches?(left, :>=, right) do
    left >= right
  end

  def matches?(left, :eq, right) do
    matches?(left, :===, right)
  end

  def matches?(left, :lt, right) do
    matches?(left, :<, right)
  end

  def matches?(left, :gt, right) do
    matches?(left, :>, right)
  end

  def matches?(left, :lte, right) do
    matches?(left, :<=, right)
  end

  def matches?(left, :gte, right) do
    matches?(left, :>=, right)
  end
end
