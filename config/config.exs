use Mix.Config

import_config "environment.exs"

# Configure Phoenix
config :phoenix, :json_library, Jason

force_ssl = Environment.get_boolean("FORCE_SSL")
scheme = if force_ssl == true, do: "https", else: "http"
host = Environment.get("CANONICAL_HOST")
port = Environment.get("PORT")

# General application configuration
config :phoenix_boilerplate,
  canonical_host: host,
  ecto_repos: [PhoenixBoilerplate.Repo],
  force_ssl: force_ssl

# Configure Repo with Postgres
config :phoenix_boilerplate, PhoenixBoilerplate.Repo,
  size: Environment.get("DATABASE_POOL_SIZE"),
  ssl: Environment.get_boolean("DATABASE_SSL"),
  url: Environment.get("DATABASE_URL")

# Configure the endpoint
config :phoenix_boilerplate, PhoenixBoilerplateWeb.Endpoint,
  debug_errors: Environment.get("DEBUG_ERRORS"),
  http: [port: port],
  pubsub: [name: PhoenixBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2],
  render_errors: [view: PhoenixBoilerplateWeb.Errors.View, accepts: ~w(html json)],
  secret_key_base: Environment.get("SECRET_KEY_BASE"),
  session_key: Environment.get("SESSION_KEY"),
  signing_salt: Environment.get("SIGNING_SALT"),
  static_url: [
    scheme: Environment.get("STATIC_URL_SCHEME"),
    host: Environment.get("STATIC_URL_HOST"),
    port: Environment.get("STATIC_URL_PORT")
  ],
  url: [scheme: scheme, host: host, port: port]

# Configure Basic Auth
if Environment.exists?("BASIC_AUTH_USERNAME") do
  config :phoenix_boilerplate,
    basic_auth: [
      username: Environment.get("BASIC_AUTH_USERNAME"),
      password: Environment.get("BASIC_AUTH_PASSWORD")
    ]
end

# Configure Gettext
config :phoenix_boilerplate, PhoenixBoilerplate.Gettext, default_locale: "en"

# Configure Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Sentry
config :sentry,
  dsn: Environment.get("SENTRY_DSN"),
  environment_name: Environment.get("SENTRY_ENVIRONMENT_NAME"),
  included_environments: [:prod],
  root_source_code_path: File.cwd!()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
