defmodule PhoenixBoilerplateWeb.Health.Controller do
  use Phoenix.Controller

  import PhoenixBoilerplate.Gettext

  def index(conn, _) do
    text(conn, dgettext("health", "ok"))
  end
end
