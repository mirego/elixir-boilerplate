defmodule ElixirBoilerplateGraphQL.Schema do
  use Absinthe.Schema

  alias ElixirBoilerplate.Repo

  defmodule Introspection do
    @enable_introspection Application.compile_env(:elixir_boilerplate, ElixirBoilerplateGraphQL)[:enable_introspection]

    if @enable_introspection do
      def pipeline(pipeline), do: pipeline
    else
      def pipeline(pipeline), do: Absinthe.Pipeline.without(pipeline, Absinthe.Phase.Schema.Introspection)
    end
  end

  @pipeline_modifier Introspection

  import_types(Absinthe.Type.Custom)
  import_types(ElixirBoilerplateGraphQL.Application.Types)

  query do
    import_fields(:application_queries)
  end

  # Even if having an empty mutation block is valid and works in Ansinthe, it
  # causes a Javascript error in GraphiQL so uncomment it when you add the
  # first mutation.
  #
  # mutation do
  # end

  def context(context) do
    Map.put(context, :loader, Dataloader.add_source(Dataloader.new(), Repo, Dataloader.Ecto.new(Repo)))
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _, _) do
    [NewRelic.Absinthe.Middleware, ElixirBoilerplateGraphQL.Middleware.OperationNameLogger] ++ middleware
  end
end
