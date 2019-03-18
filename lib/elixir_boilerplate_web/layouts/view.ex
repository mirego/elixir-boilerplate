defmodule ElixirBoilerplateWeb.Layouts.View do
  use Phoenix.View, root: "lib/elixir_boilerplate_web", path: "layouts/templates", namespace: ElixirBoilerplateWeb
  use Phoenix.HTML

  import Phoenix.Controller, only: [get_flash: 2]

  alias ElixirBoilerplateWeb.Router.Helpers, as: Routes
end
