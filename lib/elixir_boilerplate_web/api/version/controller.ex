defmodule ElixirBoilerplateWeb.Api.Version.Controller do
  use ElixirBoilerplateWeb, :controller

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _) do
    json(conn, %{version: Application.get_env(:elixir_boilerplate, :version)})
  end
end
