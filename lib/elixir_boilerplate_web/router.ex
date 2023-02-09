defmodule ElixirBoilerplateWeb.Router do
  use Phoenix.Router

  pipeline :browser do
    plug(:accepts, ~w[html json])

    plug(:session)
    plug(:fetch_session)
    plug(:fetch_flash)

    plug(:protect_from_forgery)

    plug(:put_root_layout, {ElixirBoilerplateWeb.Layouts, :root})
  end

  pipeline :api do
    plug(:accepts, ~w[json])

    plug(:session)
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
        socket: ElixirBoilerplateWeb.Socket
      )
    end
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  defp session(conn, _opts) do
    opts =
      Plug.Session.init(
        store: :cookie,
        key: Application.get_env(:elixir_boilerplate, __MODULE__)[:session_key],
        signing_salt: Application.get_env(:elixir_boilerplate, __MODULE__)[:session_signing_salt]
      )

    Plug.Session.call(conn, opts)
  end
end
