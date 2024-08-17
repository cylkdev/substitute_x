defmodule SubstituteX.Config do
  @moduledoc false
  @app :substitute_x

  @doc false
  @spec inline :: true | false
  def inline, do: Application.get_env(@app, :inline) || false

  @doc false
  @spec comparison_engine :: module() | nil
  def comparison_engine, do: Application.get_env(@app, :comparison_engine)
end
