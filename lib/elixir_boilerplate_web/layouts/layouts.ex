defmodule ElixirBoilerplateWeb.Layouts do
  @moduledoc false
  use Phoenix.Component

  alias ElixirBoilerplateWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.JS

  embed_templates("templates/*")

  attr(:flash, :map, required: true)
  attr(:kind, :atom, required: true)
  def flash(assigns)

  def hide_flash(id) do
    "lv:clear-flash"
    |> JS.push()
    |> JS.hide(to: id)
  end
end
