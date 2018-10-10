use Mix.Config

defmodule Utilities do
  def string_to_boolean("true"), do: true
  def string_to_boolean("1"), do: true
  def string_to_boolean(_), do: false
end

force_ssl = System.get_env("FORCE_SSL") |> Utilities.string_to_boolean()
schema = if force_ssl == true, do: "https", else: "http"
host = System.get_env("CANONICAL_HOST")
port = System.get_env("PORT")

# General application configuration
config :phoenix_boilerplate,
  canonical_host: host,
  ecto_repos: [PhoenixBoilerplate.Repo],
  force_ssl: force_ssl

# Configure Repo with Postgres
config :phoenix_boilerplate, PhoenixBoilerplate.Repo,
  adapter: Ecto.Adapters.Postgres,
  size: System.get_env("DATABASE_POOL_SIZE"),
  ssl: System.get_env("DATABASE_SSL") |> Utilities.string_to_boolean(),
  url: System.get_env("DATABASE_URL")

# Configure the endpoint
config :phoenix_boilerplate, PhoenixBoilerplateWeb.Endpoint,
  debug_errors: System.get_env("DEBUG_ERRORS"),
  http: [port: port],
  pubsub: [name: PhoenixBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2],
  render_errors: [view: PhoenixBoilerplateWeb.Errors.View, accepts: ~w(html json)],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  session_key: System.get_env("SESSION_KEY"),
  static_url: [
    scheme: System.get_env("STATIC_URL_SCHEME"),
    host: System.get_env("STATIC_URL_HOST"),
    port: System.get_env("STATIC_URL_PORT")
  ],
  url: [scheme: schema, host: host, port: port]

# Configure Basic Auth
if System.get_env("BASIC_AUTH_USERNAME") && System.get_env("BASIC_AUTH_USERNAME") |> String.trim() != "" do
  config :phoenix_boilerplate,
    basic_auth: [
      username: System.get_env("BASIC_AUTH_USERNAME"),
      password: System.get_env("BASIC_AUTH_PASSWORD")
    ]
end

# Configure Gettext
config :phoenix_boilerplate, PhoenixBoilerplate.Gettext, default_locale: "en"

# Configure Elixir’s Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Sentry
config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  environment_name: Mix.env(),
  included_environments: [:prod],
  root_source_code_path: File.cwd!()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
