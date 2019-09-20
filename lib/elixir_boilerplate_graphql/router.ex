defmodule ElixirBoilerplateGraphQL.Router do
  use Plug.Router

  @absinthe_configuration [
    document_providers: {ElixirBoilerplateGraphQL, :document_providers},
    json_codec: Jason,
    schema: ElixirBoilerplateGraphQL.Schema
  ]

  plug(ElixirBoilerplateGraphQL.Plugs.Context)

  plug(:match)
  plug(:dispatch)

  forward("/graphql",
    to: Absinthe.Plug,
    init_opts: @absinthe_configuration
  )

  forward("/graphiql",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [interface: :playground] ++ @absinthe_configuration
  )

  match(_, do: conn)
end
