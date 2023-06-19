defmodule ElixirBoilerplateWeb.Router do
  use ElixirBoilerplateWeb, :router

  pipeline :browser do
    plug(:accepts, ~w[html json])

    plug :fetch_session
    plug :fetch_live_flash

    plug(:protect_from_forgery)
    plug(ElixirBoilerplateWeb.Plugs.Security)

    plug(:put_root_layout, html: {ElixirBoilerplateWeb.Layouts, :root})
  end

  pipeline :api do
    plug(:accepts, ~w[json])
  end

  scope "/", ElixirBoilerplateWeb do
    pipe_through :browser

    get("/", PageController, :home)
  end

  scope "/api" do
    pipe_through :api

    forward("/graphql", Absinthe.Plug, schema: ElixirBoilerplateGraphQL.Schema)

    if Mix.env() == :dev do
      forward("/graphiql", Absinthe.Plug.GraphiQL,
        schema: ElixirBoilerplateGraphQL.Schema,
        socket: ElixirBoilerplateWeb.Socket,
        interface: :playground
      )
    end
  end

  forward(
    "/health",
    PlugCheckup,
    PlugCheckup.Options.new(
      json_encoder: Phoenix.json_library(),
      checks: ElixirBoilerplateWeb.Healthcheck.checks(),
      error_code: ElixirBoilerplateWeb.Healthcheck.error_code(),
      timeout: :timer.seconds(5),
      pretty: false
    )
  )
end
