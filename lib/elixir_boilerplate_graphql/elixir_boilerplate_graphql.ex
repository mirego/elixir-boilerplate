defmodule ElixirBoilerplateGraphQL do
  def document_providers(_) do
    [Absinthe.Plug.DocumentProvider.Default, ElixirBoilerplateGraphQL.CompiledQueries]
  end
end
