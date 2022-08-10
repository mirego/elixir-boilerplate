defmodule ElixirBoilerplateGraphQL.Router do
  use Plug.Router

  defmodule GraphQL do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    forward("/",
      to: Absinthe.Plug,
      init_opts: [
        json_codec: Jason,
        schema: ElixirBoilerplateGraphQL.Schema
      ]
    )
  end

  plug(ElixirBoilerplateGraphQL.Plugs.Context)

  plug(:match)
  plug(:dispatch)

  forward("/graphql", to: GraphQL)

  match(_, do: conn)
end
