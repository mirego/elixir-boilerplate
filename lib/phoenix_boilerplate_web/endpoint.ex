defmodule PhoenixBoilerplateWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :phoenix_boilerplate

  socket(
    "/socket",
    PhoenixBoilerplateWeb.Socket,
    websocket: true
  )

  plug(:canonical_host)
  plug(:force_ssl)
  plug(:basic_auth)
  plug(:session)

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(Plug.Static, at: "/", from: :phoenix_boilerplate, gzip: false, only: ~w(css fonts images js favicon.ico))

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket(
      "/phoenix/live_reload/socket",
      Phoenix.LiveReloader.Socket,
      websocket: true
    )

    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  plug(PhoenixBoilerplateWeb.Router)

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = Application.get_env(:phoenix_boilerplate, PhoenixBoilerplateWeb.Endpoint)[:http][:port] || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end

  defp canonical_host(conn, _opts) do
    opts = PlugCanonicalHost.init(canonical_host: Application.get_env(:phoenix_boilerplate, :canonical_host))

    PlugCanonicalHost.call(conn, opts)
  end

  defp force_ssl(conn, _opts) do
    if Application.get_env(:phoenix_boilerplate, :force_ssl) do
      opts = Plug.SSL.init(rewrite_on: [:x_forwarded_proto])

      Plug.SSL.call(conn, opts)
    else
      conn
    end
  end

  defp basic_auth(conn, _opts) do
    basic_auth_config = Application.get_env(:phoenix_boilerplate, :basic_auth)

    if basic_auth_config do
      opts = BasicAuth.init(use_config: basic_auth_config)

      BasicAuth.call(conn, opts)
    else
      conn
    end
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  defp session(conn, _opts) do
    opts =
      Plug.Session.init(
        store: :cookie,
        key: Application.get_env(:phoenix_boilerplate, PhoenixBoilerplateWeb.Endpoint)[:session_key],
        signing_salt: Application.get_env(:phoenix_boilerplate, PhoenixBoilerplateWeb.Endpoint)[:signing_salt]
      )

    Plug.Session.call(conn, opts)
  end
end
