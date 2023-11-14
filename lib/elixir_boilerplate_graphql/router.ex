defmodule ElixirBoilerplateGraphQL.Router do
  use Plug.Router

  defmodule GraphQL do
    @moduledoc false
    use Plug.Router

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

  forward("/graphql", to: GraphQL)

  match(_, do: conn)
end
