defmodule SubstituteX.ComparisonEngine do
  @moduledoc """
  Specifies the comparison API required from adapters.

  An adapter is responsible for implementing the logic
  for evaluating if the comparison of two terms is true
  given an operator.

  An adapter has two main responsibilities:

    * Define the operators available to the API (eg. `:===`).

    * Implement the logic for how two terms are compared
      when one of the pre-defined operators is given.
  """
  alias SubstituteX.Config

  @logger_prefix "SubstituteX.ComparisonEngine"

  @default_adapter SubstituteX.CommonComparison

  @doc """
  Returns a list of supported operators.
  """
  @callback operators :: list()

  @doc """
  Returns true if the operator is a supported.

  The following operators are required:

    * `:===` - Returns true if the `left` equals the `right`

  Returns a boolean.
  """
  @callback operator?(operator :: atom()) :: true | false

  @doc """
  Evaluates if the comparison of `left` and `right`
  by `operator` is `true`.

  The following operators are required:

    * `:===` - Returns true if the `left` equals the `right`

  Returns a boolean.
  """
  @callback matches?(left :: term(), operator :: term(), right :: term()) :: true | false

  @doc """
  Executes `c:SubstituteX.ComparisonEngine.operator?/1`.

  ### Options

    * `:comparison_engine` - A module that implements the behaviour `SubstituteX.ComparisonEngine`.

  ### Examples

      iex> SubstituteX.ComparisonEngine.operators()
      [:===, :!==, :<, :>, :<=, :>=, :=~, :eq, :lt, :gt, :lte, :gte]
  """
  @spec operators(opts :: keyword()) :: true | false
  @spec operators() :: true | false
  def operators(opts \\ []) do
    adapter!(opts).operators()
  end

  @doc """
  Executes `c:SubstituteX.ComparisonEngine.operator?/1`.

  ### Options

    * `:comparison_engine` - A module that implements the behaviour `SubstituteX.ComparisonEngine`.

  ### Examples

      iex> SubstituteX.ComparisonEngine.operator?(:===)
      true
  """
  @spec operator?(operator :: atom(), opts :: keyword()) :: true | false
  @spec operator?(operator :: atom()) :: true | false
  def operator?(operator, opts \\ []) do
    adapter = adapter!(opts)

    operator? = adapter.operator?(operator)

    unless operator? do
      SubstituteX.Utils.Logger.warning(
        @logger_prefix,
        "The operator '#{inspect(operator)}' is not supported by '#{inspect(adapter)}'."
      )
    end

    operator?
  end

  @doc """
  Executes `c:SubstituteX.ComparisonEngine.matches?/3`.

  ### Options

    * `:comparison_engine` - A module that implements the behaviour `SubstituteX.ComparisonEngine`.

  ### Examples

      iex> SubstituteX.ComparisonEngine.matches?("snow", :===, "snow")
      true
  """
  @spec matches?(
    left :: term(),
    operator :: term(),
    right :: term(),
    opts :: keyword()
  ) :: true | false
  @spec matches?(
    left :: term(),
    operator :: term(),
    right :: term()
  ) :: true | false
  def matches?(left, operator, right, opts \\ []) do
    adapter!(opts).matches?(left, operator, right)
  end

  defp adapter!(opts) do
    with nil <- opts[:comparison_engine],
      nil <- Config.comparison_engine() do
      @default_adapter
    end
  end
end
