defmodule ElixirBoilerplateWeb.Controllers.ErrorJSONTest do
  use ElixirBoilerplateWeb.ConnCase, async: true

  alias ElixirBoilerplateWeb.Controllers.ErrorJSON

  test "renders 404" do
    assert ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
