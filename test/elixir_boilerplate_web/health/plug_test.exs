defmodule ElixirBoilerplateWeb.Health.PlugTest do
  use ElixirBoilerplateWeb.ConnCase

  test "GET /health", %{conn: conn} do
    conn = get(conn, "/health")
    assert json_response(conn, 200) == %{
      "status" => "ok",
      "version" => Application.spec(:elixir_boilerplate, :vsn)
    }
  end
end
