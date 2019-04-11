defmodule ElixirBoilerplateWeb.Health.PlugTest do
  use ElixirBoilerplateWeb.ConnCase

  test "GET /health", %{conn: conn} do
    conn = get(conn, "/health")
    assert html_response(conn, 200) =~ "The system looks OK."
  end
end
