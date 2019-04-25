use Mix.Config

defmodule Environment do
  @moduledoc """
  This modules provides various helpers to handle environment metadata
  """

  def get(key), do: System.get_env(key)

  def get_boolean(key) do
    case get(key) do
      "true" -> true
      "1" -> true
      _ -> false
    end
  end

  def get_integer(key) do
    case get(key) do
      value when is_bitstring(value) -> String.to_integer(value)
      _ -> nil
    end
  end

  def exists?(key) do
    case get(key) do
      "" -> false
      nil -> false
      _ -> true
    end
  end
end

force_ssl = Environment.get_boolean("FORCE_SSL")
scheme = if force_ssl, do: "https", else: "http"
host = Environment.get("CANONICAL_HOST")
port = Environment.get("PORT")

# Configure application
config :elixir_boilerplate,
  canonical_host: host,
  force_ssl: force_ssl

# Configure Ecto repo
config :elixir_boilerplate, ElixirBoilerplate.Repo,
  pool_size: Environment.get_integer("DATABASE_POOL_SIZE"),
  ssl: Environment.get_boolean("DATABASE_SSL"),
  url: Environment.get("DATABASE_URL")

# Configure Phoenix endpoint
config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
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
  url: [scheme: scheme, host: host, port: port]

# Configure Basic Auth
if Environment.exists?("BASIC_AUTH_USERNAME") do
  config :elixir_boilerplate,
    basic_auth: [
      username: Environment.get("BASIC_AUTH_USERNAME"),
      password: Environment.get("BASIC_AUTH_PASSWORD")
    ]
end

# Configure Sentry
config :sentry,
  dsn: Environment.get("SENTRY_DSN"),
  environment_name: Environment.get("SENTRY_ENVIRONMENT_NAME")
