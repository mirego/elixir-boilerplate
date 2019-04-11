defmodule ElixirBoilerplateWeb.Health.Plug do
  use Plug.Builder

  def call(%{request_path: "/health"} = conn, _) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok", version: Application.spec(:elixir_boilerplate, :vsn)}))
    |> halt()
  end

  def call(conn, _), do: conn
end
