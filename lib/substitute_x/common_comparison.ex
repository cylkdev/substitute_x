defmodule SubstituteX.CommonComparison do
  @moduledoc """
  A `SubstituteX.ComparisonEngine` adapter.
  """
  alias SubstituteX.ComparisonEngine

  @behaviour ComparisonEngine

  @operators ~w(=== < > <= >= =~ eq lt gt lte gte)a

  @impl ComparisonEngine
  @doc """
  Returns a list of supported operators.

  ### Examples

      iex> SubstituteX.CommonComparison.operators()
      [:===, :<, :>, :<=, :>=, :=~, :eq, :lt, :gt, :lte, :gte]
  """
  @spec operators :: list()
  def operators, do: @operators

  @impl ComparisonEngine
  @doc """
  Returns `true` if the `operator` is supported.

  The following operators are supported:

    * `:===`
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
      iex> SubstituteX.CommonComparison.compare?(1, :===, 1)
      true
  """
  @spec compare?(left :: any(), operator :: any(), right :: any()) :: boolean()
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
end
