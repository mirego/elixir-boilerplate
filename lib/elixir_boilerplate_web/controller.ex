defmodule ElixirBoilerplateWeb.Controller do
  defmacro __using__(_opts) do
    quote do
      use Phoenix.Controller,
        namespace: ElixirBoilerplateWeb,
        formats: [:html, :json],
        layouts: [html: ElixirBoilerplateWeb.Layouts]

      import Plug.Conn
      import ElixirBoilerplate.Gettext

      unquote(ElixirBoilerplateWeb.verified_routes())
    end
  end
end
