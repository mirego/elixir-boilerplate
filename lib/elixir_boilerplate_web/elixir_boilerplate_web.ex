defmodule ElixirBoilerplateWeb do
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML

      # Core UI components and translation
      import ElixirBoilerplate.Gettext
      import ElixirBoilerplateWeb.Components.Core

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: ElixirBoilerplateWeb.Endpoint,
        router: ElixirBoilerplateWeb.Router,
        statics: ElixirBoilerplateWeb.static_paths()
    end
  end
end
