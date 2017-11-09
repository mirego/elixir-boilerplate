use Mix.Config

defmodule Utilities do
  def string_to_boolean("true"), do: true
  def string_to_boolean("1"), do: true
  def string_to_boolean(_), do: false
end

# General application configuration
config :phoenix_boilerplate,
  ecto_repos: [PhoenixBoilerplate.Repo]

# Configures the endpoint
config :phoenix_boilerplate, PhoenixBoilerplateWeb.Endpoint,
  http: [port: System.get_env("PORT")],
  url: [host: System.get_env("CANONICAL_HOST") || "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: PhoenixBoilerplateWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure your database
config :phoenix_boilerplate, PhoenixBoilerplate.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL")

# Configure SSL
config :phoenix_boilerplate, force_ssl: Utilities.string_to_boolean(System.get_env("FORCE_SSL"))

# Configure Basic Auth
if System.get_env("BASIC_AUTH_USERNAME") do
  config :phoenix_boilerplate, basic_auth: [
    username: System.get_env("BASIC_AUTH_USERNAME"),
    password: System.get_env("BASIC_AUTH_PASSWORD")
  ]
end

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  included_environments: [:prod],
  environment_name: Mix.env,
  use_error_logger: true,
  root_source_code_path: File.cwd!,
  enable_source_code_context: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
