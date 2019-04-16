use Mix.Config

defmodule Utils do
  defmodule Environment do
    @moduledoc """
    This modules provides various helpers to handle data stored
    in environment variables (obtained via `System.get_env/1`).
    """

    def get(key), do: System.get_env(key)

    def get_boolean(key) do
      key
      |> get()
      |> parse_boolean()
    end

    def get_integer(key, default \\ 0) do
      key
      |> get()
      |> parse_integer(default)
    end

    def exists?(key) do
      key
      |> get()
      |> case do
        "" -> false
        nil -> false
        _ -> true
      end
    end

    defp parse_boolean("true"), do: true
    defp parse_boolean("1"), do: true
    defp parse_boolean(_), do: false

    defp parse_integer(value, _) when is_bitstring(value), do: String.to_integer(value)
    defp parse_integer(_, default), do: default
  end

  defmodule Version do
    @moduledoc """
    This modules exposes the application version number, either
    through the application spec (when building an OTP release) or
    the project configuration (when compiling the code with `mix`).
    """

    def get do
      :elixir_boilerplate
      |> Application.spec(:vsn)
      |> case do
        nil -> Mix.Project.config()[:version]
        version -> to_string(version)
      end
    end
  end
end

force_ssl = Utils.Environment.get_boolean("FORCE_SSL")
scheme = if force_ssl, do: "https", else: "http"
host = Utils.Environment.get("CANONICAL_HOST")
port = Utils.Environment.get("PORT")

# General application configuration
config :elixir_boilerplate,
  version: Utils.Version.get(),
  canonical_host: host,
  force_ssl: force_ssl,
  ecto_repos: [ElixirBoilerplate.Repo]

# Configure Phoenix
config :phoenix, :json_library, Jason

# Configure Repo with Postgres
config :elixir_boilerplate, ElixirBoilerplate.Repo,
  pool_size: Utils.Environment.get_integer("DATABASE_POOL_SIZE"),
  ssl: Utils.Environment.get_boolean("DATABASE_SSL"),
  url: Utils.Environment.get("DATABASE_URL")

# Configures Phoenix endpoint
config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  debug_errors: Utils.Environment.get_boolean("DEBUG_ERRORS"),
  http: [port: port],
  secret_key_base: Utils.Environment.get("SECRET_KEY_BASE"),
  session_key: Utils.Environment.get("SESSION_KEY"),
  signing_salt: Utils.Environment.get("SIGNING_SALT"),
  static_url: [
    scheme: Utils.Environment.get("STATIC_URL_SCHEME"),
    host: Utils.Environment.get("STATIC_URL_HOST"),
    port: Utils.Environment.get("STATIC_URL_PORT")
  ],
  url: [scheme: scheme, host: host, port: port],
  pubsub: [name: ElixirBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2],
  render_errors: [view: ElixirBoilerplateWeb.Errors.View, accepts: ~w(html json)]

# Configure Gettext
config :elixir_boilerplate, ElixirBoilerplate.Gettext, default_locale: "en"

# Configure Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Basic Auth
if Utils.Environment.exists?("BASIC_AUTH_USERNAME") do
  config :elixir_boilerplate,
    basic_auth: [
      username: Utils.Environment.get("BASIC_AUTH_USERNAME"),
      password: Utils.Environment.get("BASIC_AUTH_PASSWORD")
    ]
end

# Configure Sentry
config :sentry,
  dsn: Utils.Environment.get("SENTRY_DSN"),
  environment_name: Utils.Environment.get("SENTRY_ENVIRONMENT_NAME"),
  included_environments: [:prod],
  root_source_code_path: File.cwd!(),
  release: Utils.Version.get()
