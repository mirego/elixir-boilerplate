defmodule ElixirBoilerplateWeb.HTML do
  defmacro __using__(_) do
    quote do
      use Phoenix.HTML

      import ElixirBoilerplateWeb.DataIdentifier
    end
  end
end
