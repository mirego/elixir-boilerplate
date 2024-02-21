# credo:disable-for-this-file CredoNaming.Check.Consistency.ModuleFilename
defmodule ElixirBoilerplateWeb.Errors.ErrorJsonTest do
  use ElixirBoilerplate.DataCase, async: true

  alias ElixirBoilerplateWeb.Errors.ErrorJSON

  test "renders 404" do
    assert ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ErrorJSON.render("500.json", %{}) == %{errors: %{detail: "Internal Server Error"}}
  end
end
