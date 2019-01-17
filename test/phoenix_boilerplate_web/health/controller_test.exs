defmodule PhoenixBoilerplateWeb.Health.ControllerTest do
  use PhoenixBoilerplateWeb.ConnCase

  test "GET /health", %{conn: conn} do
    conn = get(conn, "/health")
    assert text_response(conn, 200) == "The system looks OK."
  end
end
