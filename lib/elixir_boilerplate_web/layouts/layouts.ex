defmodule ElixirBoilerplateWeb.Layouts do
  use ElixirBoilerplateWeb, :html

  embed_templates("templates/*")

  def hide_flash(id) do
    "lv:clear-flash"
    |> JS.push()
    |> JS.hide(to: id)
  end
end
