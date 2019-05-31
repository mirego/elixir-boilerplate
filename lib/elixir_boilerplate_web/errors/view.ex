defmodule ElixirBoilerplateWeb.Errors.View do
  use Phoenix.View, root: "lib/elixir_boilerplate_web", path: "errors/templates", namespace: ElixirBoilerplateWeb

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
