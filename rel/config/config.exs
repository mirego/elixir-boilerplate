use Mix.Config

defmodule Utilities do
  def string_to_boolean("true"), do: true
  def string_to_boolean("1"), do: true
  def string_to_boolean(_), do: false
end

schema = if (System.get_env("FORCE_SSL") |> Utilities.string_to_boolean()) do
  "https"
else
  "http"
end
host = System.get_env("CANONICAL_HOST")
port = System.get_env("PORT")

# Configure Repo with Postgres
config :phoenix_boilerplate, PhoenixBoilerplate.Repo,
  size: System.get_env("DATABASE_POOL_SIZE"),
  ssl: System.get_env("DATABASE_SSL") |> Utilities.string_to_boolean(),
  url: System.get_env("DATABASE_URL")

# Configures the endpoint
config :phoenix_boilerplate, PhoenixBoilerplateWeb.Endpoint,
  debug_errors: System.get_env("DEBUG_ERRORS"),
  http: [port: port],
  root: ".",
  server: true,
  static_url: [
    scheme: System.get_env("STATIC_URL_SCHEME"),
    host: System.get_env("STATIC_URL_HOST"),
    port: System.get_env("STATIC_URL_PORT")
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  session_key: System.get_env("SESSION_KEY"),
  url: [schema: schema, host: host, port: port]
