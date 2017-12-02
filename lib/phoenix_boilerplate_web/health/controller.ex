defmodule PhoenixBoilerplateWeb.Health.Controller do
  use Phoenix.Controller

  def index(conn, _) do
    text conn, "ok"
  end
end
