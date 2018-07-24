use Mix.Config

defmodule Utilities do
  def string_to_boolean("true"), do: true
  def string_to_boolean("1"), do: true
  def string_to_boolean(_), do: false
end

{force_ssl, endpoint_url} =
  if Utilities.string_to_boolean(System.get_env("FORCE_SSL")) do
    {true, [schema: "https", port: 443, host: System.get_env("CANONICAL_HOST")]}
  else
    {false, [schema: "http", port: 80, host: System.get_env("CANONICAL_HOST")]}
  end

# General application configuration
config :phoenix_boilerplate, ecto_repos: [PhoenixBoilerplate.Repo]

# Configures the endpoint
config :phoenix_boilerplate, PhoenixBoilerplateWeb.Endpoint,
  http: [port: System.get_env("PORT")],
  pubsub: [name: PhoenixBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2],
  render_errors: [view: PhoenixBoilerplateWeb.Errors.View, accepts: ~w(html json)],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  session_key: System.get_env("SESSION_KEY"),
  static_url: [
    scheme: System.get_env("CDN_SCHEME"),
    host: System.get_env("CDN_HOST"),
    port: System.get_env("CDN_PORT")
  ],
  url: endpoint_url

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure your database
config :phoenix_boilerplate, PhoenixBoilerplate.Repo,
  adapter: Ecto.Adapters.Postgres,
  ssl: Utilities.string_to_boolean(System.get_env("DATABASE_SSL")),
  size: System.get_env("DATABASE_POOL_SIZE"),
  url: System.get_env("DATABASE_URL")

# Configure SSL
config :phoenix_boilerplate,
  canonical_host: System.get_env("CANONICAL_HOST"),
  force_ssl: force_ssl

# Configure Basic Auth
if System.get_env("BASIC_AUTH_USERNAME") && String.trim(System.get_env("BASIC_AUTH_USERNAME")) != "" do
  config :phoenix_boilerplate,
    basic_auth: [
      username: System.get_env("BASIC_AUTH_USERNAME"),
      password: System.get_env("BASIC_AUTH_PASSWORD")
    ]
end

# Configures Sentry to report errors
config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  environment_name: Mix.env(),
  included_environments: [:prod],
  root_source_code_path: File.cwd!()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
