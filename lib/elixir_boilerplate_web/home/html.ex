defmodule ElixirBoilerplateWeb.Home.HTML do
  use ElixirBoilerplateWeb, :html

  embed_templates("templates/*")

  def render("index.html", assigns), do: index(assigns)

  attr(:text, :string, required: true)
  attr(:class, :string, default: nil)
  def message(assigns)
end
