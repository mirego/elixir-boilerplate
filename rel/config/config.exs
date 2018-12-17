use Mix.Config

defmodule Environment do
  @moduledoc """
  This modules provdes various helpers to handle data stored
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

force_ssl = Environment.get_boolean("FORCE_SSL")
scheme = if force_ssl, do: "https", else: "http"
host = Environment.get("CANONICAL_HOST")
port = Environment.get("PORT")

# General application configuration
config :phoenix_boilerplate,
  canonical_host: host,
  force_ssl: force_ssl,
  ecto_repos: [PhoenixBoilerplate.Repo]

# Configure Phoenix
config :phoenix, :json_library, Jason

# Configure Repo with Postgres
config :phoenix_boilerplate, PhoenixBoilerplate.Repo,
  size: Environment.get("DATABASE_POOL_SIZE"),
  ssl: Environment.get_boolean("DATABASE_SSL"),
  url: Environment.get("DATABASE_URL")

# Configures Phoenix endpoint
config :phoenix_boilerplate, PhoenixBoilerplateWeb.Endpoint,
  root: ".",
  server: true,
  debug_errors: Environment.get_boolean("DEBUG_ERRORS"),
  http: [port: port],
  secret_key_base: Environment.get("SECRET_KEY_BASE"),
  session_key: Environment.get("SESSION_KEY"),
  signing_salt: Environment.get("SIGNING_SALT"),
  static_url: [
    scheme: Environment.get("STATIC_URL_SCHEME"),
    host: Environment.get("STATIC_URL_HOST"),
    port: Environment.get("STATIC_URL_PORT")
  ],
  url: [scheme: scheme, host: host, port: port],
  pubsub: [name: PhoenixBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2],
  render_errors: [view: PhoenixBoilerplateWeb.Errors.View, accepts: ~w(html json)]

# Configure Gettext
config :phoenix_boilerplate, PhoenixBoilerplate.Gettext, default_locale: "en"

# Configure Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Basic Auth
if Environment.exists?("BASIC_AUTH_USERNAME") do
  config :phoenix_boilerplate,
    basic_auth: [
      username: Environment.get("BASIC_AUTH_USERNAME"),
      password: Environment.get("BASIC_AUTH_PASSWORD")
    ]
end

# Configure Sentry
config :sentry,
  dsn: Environment.get("SENTRY_DSN"),
  environment_name: Environment.get("SENTRY_ENVIRONMENT_NAME"),
  included_environments: [:prod],
  root_source_code_path: File.cwd!()
