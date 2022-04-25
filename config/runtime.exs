import Config
import ElixirBoilerplate.Config

canonical_uri = get_env("CANONICAL_URL", :uri)
static_uri = get_env("STATIC_URL", :uri)

config :elixir_boilerplate,
  canonical_host: get_uri_part(canonical_uri, :host),
  force_ssl: get_uri_part(canonical_uri, :scheme) == "https"

config :elixir_boilerplate, ElixirBoilerplate.Repo,
  url: get_env!("DATABASE_URL"),
  ssl: get_env("DATABASE_SSL", :boolean),
  pool_size: get_env!("DATABASE_POOL_SIZE", :integer)

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  http: [port: get_env!("PORT", :integer)],
  secret_key_base: get_env!("SECRET_KEY_BASE"),
  url: get_endpoint_url_config(canonical_uri),
  static_url: get_endpoint_url_config(static_uri),
  debug_errors: get_env("DEBUG_ERRORS", :boolean)

config :elixir_boilerplate, ElixirBoilerplateWeb.Router,
  session_key: get_env!("SESSION_KEY"),
  session_signing_salt: get_env!("SESSION_SIGNING_SALT")

config :elixir_boilerplate, Corsica, origins: get_env("CORS_ALLOWED_ORIGINS", :cors)

config :elixir_boilerplate,
  basic_auth: [
    username: get_env("BASIC_AUTH_USERNAME"),
    password: get_env("BASIC_AUTH_PASSWORD")
  ]

config :sentry,
  dsn: get_env("SENTRY_DSN"),
  environment_name: get_env("SENTRY_ENVIRONMENT_NAME"),
  included_environments: [get_env("SENTRY_ENVIRONMENT_NAME")]

config :new_relic_agent,
  app_name: get_env("NEW_RELIC_APP_NAME"),
  license_key: get_env("NEW_RELIC_LICENSE_KEY")
