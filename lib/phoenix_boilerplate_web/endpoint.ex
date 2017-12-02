defmodule PhoenixBoilerplateWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :phoenix_boilerplate

  socket "/socket", PhoenixBoilerplateWeb.Socket

  if Application.get_env(:phoenix_boilerplate, :force_ssl) do
    plug Plug.SSL, rewrite_on: [:x_forwarded_proto]
  end

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :phoenix_boilerplate, gzip: false,
    only: ~w(css fonts images js favicon.ico)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: System.get_env("SESSION_KEY"),
    signing_salt: "G5pYBEen"

  if Application.get_env(:phoenix_boilerplate, :basic_auth) do
    plug BasicAuth, use_config: {:phoenix_boilerplate, :basic_auth}
  end

  plug PhoenixBoilerplateWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
