defmodule ElixirBoilerplateWeb.Health.Plug do
  use Plug.Builder

  def call(%{request_path: "/health"} = conn, _) do
    version =
      :elixir_boilerplate
      |> Application.spec(:vsn)
      |> String.Chars.to_string()

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok", version: version}))
    |> halt()
  end

  def call(conn, _), do: conn
end
