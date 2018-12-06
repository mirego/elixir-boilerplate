use Mix.Config

import_config "environment.exs"

force_ssl = Environment.get_boolean("FORCE_SSL")
scheme = if force_ssl, do: "https", else: "http"
host = Environment.get("CANONICAL_HOST")
port = Environment.get("PORT")

# General application configuration
config :phoenix_boilerplate,
  canonical_host: host,
  force_ssl: force_ssl

# Configure Repo with Postgres
config :phoenix_boilerplate, PhoenixBoilerplate.Repo,
  size: Environment.get("DATABASE_POOL_SIZE"),
  ssl: Environment.get_boolean("DATABASE_SSL"),
  url: Environment.get("DATABASE_URL")

# Configures the endpoint
config :phoenix_boilerplate, PhoenixBoilerplateWeb.Endpoint,
  debug_errors: Environment.get("DEBUG_ERRORS"),
  http: [port: port],
  root: ".",
  secret_key_base: Environment.get("SECRET_KEY_BASE"),
  server: true,
  session_key: Environment.get("SESSION_KEY"),
  signing_salt: Environment.get("SIGNING_SALT"),
  static_url: [
    scheme: Environment.get("STATIC_URL_SCHEME"),
    host: Environment.get("STATIC_URL_HOST"),
    port: Environment.get("STATIC_URL_PORT")
  ],
  url: [scheme: scheme, host: host, port: port]

# Configure Sentry
config :sentry,
  dsn: Environment.get("SENTRY_DSN"),
  environment_name: Environment.get("SENTRY_ENVIRONMENT_NAME")
