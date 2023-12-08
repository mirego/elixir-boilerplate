defmodule ElixirBoilerplateGraphQL.Router do
  use Plug.Router

  defmodule GraphQL do
    @moduledoc false
    use Plug.Router

    plug(
      Plug.Parsers,
      parsers: [:json],
      pass: [],
      json_decoder: Phoenix.json_library()
    )

    plug(:match)
    plug(:dispatch)

    forward("/",
      to: Absinthe.Plug,
      init_opts: ElixirBoilerplateGraphQL.configuration()
    )
  end

  plug(ElixirBoilerplateGraphQL.Plugs.Context)

  plug(:match)
  plug(:dispatch)

  # It is intentional that we do not *serve* GraphiQL as part of the API.
  # Developers should use standalone GraphQL clients that connect to the API instead.
  forward("/graphql", to: GraphQL)

  match(_, do: conn)
end
