defmodule ElixirBoilerplateWeb.Home.ControllerTest do
  use ElixirBoilerplateWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    html_response = html_response(conn, 200)

    assert html_response =~ "Hello, world!"
    assert html_response =~ "data-testid=\"description-paragraph\""
    assert html_response =~ "data-testid=\"message-paragraph\""
  end
end
