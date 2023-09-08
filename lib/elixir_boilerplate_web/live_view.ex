defmodule ElixirBoilerplateWeb.LiveView do
  defmacro __using__(_opts) do
    quote do
      use Phoenix.LiveView, layout: {ElixirBoilerplateWeb.Layouts, :live}

      unquote(ElixirBoilerplateWeb.html_helpers())
    end
  end
end
