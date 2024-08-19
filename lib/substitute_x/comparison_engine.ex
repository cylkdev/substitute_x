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

  @default_adapter SubstituteX

  @doc """
  Evaluates if the comparison of `left` and `right`
  by `operator` is `true`.

  The following operators are required:

    * `:===` - Returns true if the `left` equals the `right`

  Returns a boolean.
  """
  @callback compare?(left :: term(), operator :: term(), right :: term()) :: true | false

  @doc """
  Executes `c:compare?/3`.

  ### Options

    * `:comparison_engine` - A module that implements the behaviour `SubstituteX.ComparisonEngine`.

  ### Examples

      iex> SubstituteX.ComparisonEngine.compare?("snow", :===, "snow", comparison_engine: SubstituteX)
      true
  """
  @spec compare?(
    left :: term(),
    operator :: term(),
    right :: term(),
    opts :: keyword()
  ) :: true | false
  def compare?(left, operator, right, opts \\ []) do
    adapter!(opts).compare?(left, operator, right)
  end

  defp adapter!(opts) do
    opts[:comparison_engine] || Config.comparison_engine() || @default_adapter
  end
end
