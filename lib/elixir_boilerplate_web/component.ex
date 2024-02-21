defmodule ElixirBoilerplateWeb.Component do
  defmacro __using__(_opts) do
    quote do
      use Phoenix.LiveComponent

      unquote(ElixirBoilerplateWeb.html_helpers())
    end
  end
end
