defmodule ElixirBoilerplateWeb.Router do
  use Phoenix.Router, helpers: false

  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(
      Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json],
      pass: ["*/*"],
      json_decoder: Phoenix.json_library()
    )

    plug(:accepts, ~w[html json])

    plug(:fetch_session)
    plug(:fetch_live_flash)

    plug(:protect_from_forgery)
    plug(ElixirBoilerplateWeb.Plugs.Security)

    plug(:put_layout, {ElixirBoilerplateWeb.Layouts, :app})
    plug(:put_root_layout, {ElixirBoilerplateWeb.Layouts, :root})
  end

  pipeline :api do
    plug(:accepts, ~w[json])
  end

  scope "/" do
    pipe_through :browser

    # To enable metrics dashboard use `telemetry_ui_allowed: true` as assigns value
    #
    # Metrics can contains sensitive data you should protect it under authorization
    # See https://github.com/mirego/telemetry_ui#security
    get("/metrics", TelemetryUI.Web, [], assigns: %{telemetry_ui_allowed: false})
  end

  scope "/", ElixirBoilerplateWeb do
    pipe_through :browser

    get("/", Home.Controller, :index, as: :home)
    live("/live", Home.Live, :index, as: :live_home)
  end

  scope "/api", ElixirBoilerplateWeb.Api do
    pipe_through :api

    get("/version", Version.Controller, :index, as: :version)
  end

  scope "/" do
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
      checks: ElixirBoilerplateHealth.checks(),
      error_code: ElixirBoilerplateHealth.error_code(),
      timeout: :timer.seconds(5),
      pretty: false
    )
  )
end
