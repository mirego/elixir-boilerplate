defmodule ElixirBoilerplateWeb.Controllers.PageTest do
  use ElixirBoilerplateWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "stable base upon which"
  end
end
