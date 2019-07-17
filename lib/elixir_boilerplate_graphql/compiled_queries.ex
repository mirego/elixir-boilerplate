defmodule ElixirBoilerplateGraphQL.CompiledQueries do
  use Absinthe.Plug.DocumentProvider.Compiled

  "priv/graphql/compiled_queries.json"
  |> File.read!()
  |> Jason.decode!()
  |> Map.new(fn {query, id} -> {id, query} end)
  |> provide()
end
