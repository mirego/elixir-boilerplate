defmodule ElixirBoilerplateWeb.Health.Plug do
  use Plug.Builder

  def call(%{request_path: "/health"} = conn, _) do
    version = Application.get_env(:elixir_boilerplate, :version)

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok", version: version}))
    |> halt()
  end

  def call(conn, _), do: conn
end
