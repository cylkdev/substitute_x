defmodule SubstituteX.Config do
  @moduledoc false
  @app :substitute_x

  @doc false
  @spec engine :: module() | nil
  def engine, do: Application.get_env(@app, :engine)
end
