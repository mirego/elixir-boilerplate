defmodule ElixirBoilerplateWeb.Health.Plug do
  use Plug.Builder

  import ElixirBoilerplate.Gettext

  def call(%{request_path: "/health"} = conn, _) do
    conn
    |> put_resp_header("content-type", "text/html")
    |> send_resp(200, dgettext("health", "ok"))
    |> halt()
  end

  def call(conn, _), do: conn
end
