defmodule ElixirBoilerplateGraphQL.Schema do
  use Absinthe.Schema

  alias ElixirBoilerplate.Repo

  query do
  end

  mutation do
  end

  def context(context) do
    Map.put(context, :loader, Dataloader.add_source(Dataloader.new(), Repo, Dataloader.Ecto.new(Repo)))
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
