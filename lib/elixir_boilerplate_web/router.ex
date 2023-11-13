defmodule ElixirBoilerplateWeb.Router do
  use Phoenix.Router

  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html", "json"])

    plug(:session)
    plug(:fetch_session)

    plug(:protect_from_forgery)
    plug(:fetch_live_flash)

    plug(:put_layout, {ElixirBoilerplateWeb.Layouts, :app})
    plug(:put_root_layout, {ElixirBoilerplateWeb.Layouts, :root})
  end

  scope "/" do
    pipe_through(:browser)

    # To enable metrics dashboard use `telemetry_ui_allowed: true` as assigns value
    #
    # Metrics can contains sensitive data you should protect it under authorization
    # See https://github.com/mirego/telemetry_ui#security
    get("/metrics", TelemetryUI.Web, [], assigns: %{telemetry_ui_allowed: false})
  end

  scope "/", ElixirBoilerplateWeb do
    pipe_through(:browser)

    get("/", Home.Controller, :index, as: :home)
  end

  scope "/", ElixirBoilerplateWeb do
    pipe_through(:browser)

    live("/live", Home.Live, :index, as: :live_home)
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  defp session(conn, _opts) do
    opts = Plug.Session.init(ElixirBoilerplateWeb.Session.config())
    Plug.Session.call(conn, opts)
  end
end
