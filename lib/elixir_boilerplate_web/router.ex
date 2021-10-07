defmodule ElixirBoilerplateWeb.Router do
  use Phoenix.Router

  pipeline :browser do
    plug(:accepts, ["html", "json"])

    plug(:session)
    plug(:fetch_session)
    plug(:fetch_flash)

    plug(:protect_from_forgery)
    plug(ElixirBoilerplateWeb.ContentSecurityPolicy)

    plug(:put_layout, {ElixirBoilerplateWeb.Layouts.View, :app})
  end

  scope "/", ElixirBoilerplateWeb do
    pipe_through(:browser)

    get("/", Home.Controller, :index, as: :home)
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
