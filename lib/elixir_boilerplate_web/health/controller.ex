defmodule ElixirBoilerplateWeb.Health.Controller do
  use Phoenix.Controller

  import ElixirBoilerplate.Gettext

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _) do
    text(conn, dgettext("health", "ok"))
  end
end
