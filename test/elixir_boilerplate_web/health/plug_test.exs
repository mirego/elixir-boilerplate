defmodule ElixirBoilerplateWeb.Health.PlugTest do
  use ElixirBoilerplateWeb.ConnCase

  test "GET /health", %{conn: conn} do
    conn = get(conn, "/health")

    version =
      :elixir_boilerplate
      |> Application.spec(:vsn)
      |> String.Chars.to_string()

    assert json_response(conn, 200) == %{
             "status" => "ok",
             "version" => version
           }
  end
end
