defmodule ElixirBoilerplateWeb.Router do
  use ElixirBoilerplateWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {ElixirBoilerplateWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_csp)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/" do
    pipe_through(:browser)

    # To enable metrics dashboard use `telemetry_ui_allowed: true` as assigns value
    #
    # Metrics can contains sensitive data you should protect it under authorization
    # See https://github.com/mirego/telemetry_ui#security
    get("/metrics", TelemetryUI.Web, [], assigns: %{telemetry_ui_allowed: Application.compile_env(:elixir_boilerplate, :dev_routes, false)})
  end

  scope "/", ElixirBoilerplateWeb do
    pipe_through(:browser)

    get("/", Controllers.PageController, :home)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirBoilerplateWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:elixir_boilerplate, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: ElixirBoilerplateWeb.Telemetry)
    end
  end

  def put_csp(conn, _opts) do
    nonce = 16 |> :crypto.strong_rand_bytes() |> Base.encode64()

    csp =
      Enum.join(
        [
          "default-src 'self'",
          "base-uri 'self'",
          "frame-ancestors 'self'",
          "form-action 'self'",
          "img-src 'self' data:",
          "script-src 'self' 'nonce-#{nonce}'",
          "style-src 'self' 'unsafe-inline'",
          "connect-src 'self' ws: wss:",
          "font-src 'self' data:",
          "object-src 'none'",
          "upgrade-insecure-requests"
        ],
        "; "
      )

    conn
    |> assign(:csp_nonce, nonce)
    |> put_secure_browser_headers(%{"content-security-policy" => csp})
  end
end
