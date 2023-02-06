defmodule ElixirBoilerplateGraphQL.Pipeline.Introspection do
  if Application.compile_env(:elixir_boilerplate, ElixirBoilerplateGraphQL)[:enable_introspection] do
    def pipeline(pipeline), do: pipeline
  else
    def pipeline(pipeline), do: Absinthe.Pipeline.without(pipeline, Absinthe.Phase.Schema.Introspection)
  end
end
