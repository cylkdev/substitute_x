defmodule SubstituteX.Engine do
  @moduledoc """
  Specifies the comparison API required from adapters.

  This adapter is responsible for:

    * Defining the operators available to the API (eg. `:===`).

    * Implement the logic for comparing two terms given an operator.
  """
  alias SubstituteX.Config

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
  @callback operator?(operator :: any()) :: true | false

  @doc """
  Returns `true` if the evaluation of the expression
  `<left> <operator> <right>` is `true` otherwise
  returns `false`.

  The following operators are required:

    * `:===` - Returns true if the `left` equals the `right`

  Returns a boolean.
  """
  @callback evaluate?(left :: any(), operator :: any(), right :: any()) :: true | false

  @doc """
  Executes `c:SubstituteX.Engine.operators/0`.

  Returns a list.
  """
  @spec operators(opts :: keyword()) :: true | false
  @spec operators :: true | false
  def operators(opts \\ []), do: adapter!(opts).operators()

  @doc """
  Executes `c:SubstituteX.Engine.operator?/1`.

  Returns a boolean.
  """
  @spec operator?(operator :: any(), opts :: keyword()) :: true | false
  @spec operator?(operator :: any()) :: true | false
  def operator?(operator, opts \\ []), do: adapter!(opts).operator?(operator)

  @doc """
  Executes `c:SubstituteX.Engine.evaluate?/3`.

  ### Options

    * `:engine` - A module that implements the behaviour `SubstituteX.Engine`.

  ### Examples

      iex> SubstituteX.Engine.evaluate?("snow", :===, "snow")
      true
  """
  @spec evaluate?(left :: any(), operator :: any(), right :: any(), opts :: keyword()) :: true | false
  @spec evaluate?(left :: any(), operator :: any(), right :: any()) :: true | false
  def evaluate?(left, operator, right, opts \\ []) do
    adapter!(opts).evaluate?(left, operator, right)
  end

  defp adapter!(opts) do
    with nil <- opts[:engine],
      nil <- Config.engine() do
      @default_adapter
    end
  end
end
