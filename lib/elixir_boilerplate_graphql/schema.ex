defmodule ElixirBoilerplateGraphQL.Schema do
  use Absinthe.Schema

  alias ElixirBoilerplate.Repo

  import_types(Absinthe.Type.Custom)
  import_types(ElixirBoilerplateGraphQL.Types.Application)

  query do
    import_fields(:application_queries)
  end

  # mutation do
  # end

  def context(context) do
    Map.put(context, :loader, Dataloader.add_source(Dataloader.new(), Repo, Dataloader.Ecto.new(Repo)))
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
