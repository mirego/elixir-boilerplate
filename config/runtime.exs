import Config

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

  def get_cors_origins do
    case Environment.get("CORS_ALLOWED_ORIGINS") do
      origins when is_bitstring(origins) ->
        origins
        |> String.split(",")
        |> case do
          [origin] -> origin
          origins -> origins
        end

      _ ->
        nil
    end
  end

  def get_endpoint_url_config(nil), do: nil
  def get_endpoint_url_config(""), do: nil

  def get_endpoint_url_config(uri) do
    [
      host: uri.host,
      scheme: uri.scheme,
      port: uri.port
    ]
  end

  def get_uri_part(%URI{host: host}, :host), do: host
  def get_uri_part(%URI{port: port}, :port), do: port
  def get_uri_part(%URI{scheme: scheme}, :scheme), do: scheme
  def get_uri_part(_, _), do: nil

  def get_safe_uri(nil), do: nil
  def get_safe_uri(""), do: nil
  def get_safe_uri(url), do: URI.parse(url)
end

canonical_uri = Environment.get_safe_uri(Environment.get("CANONICAL_URL"))
static_uri = Environment.get_safe_uri(Environment.get("STATIC_URL"))

config :elixir_boilerplate,
  canonical_host: Environment.get_uri_part(canonical_uri, :host),
  force_ssl: Environment.get_uri_part(canonical_uri, :scheme) == "https"

config :elixir_boilerplate, ElixirBoilerplate.Repo,
  pool_size: Environment.get_integer("DATABASE_POOL_SIZE"),
  ssl: Environment.get_boolean("DATABASE_SSL"),
  url: Environment.get("DATABASE_URL")

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  debug_errors: Environment.get_boolean("DEBUG_ERRORS"),
  http: [port: Environment.get("PORT")],
  secret_key_base: Environment.get("SECRET_KEY_BASE"),
  static_url: Environment.get_endpoint_url_config(static_uri),
  url: Environment.get_endpoint_url_config(canonical_uri)

config :elixir_boilerplate, ElixirBoilerplateWeb.Router,
  session_key: Environment.get("SESSION_KEY"),
  session_signing_salt: Environment.get("SESSION_SIGNING_SALT")

config :elixir_boilerplate, Corsica, origins: Environment.get_cors_origins()

config :elixir_boilerplate,
  basic_auth: [
    username: Environment.get("BASIC_AUTH_USERNAME"),
    password: Environment.get("BASIC_AUTH_PASSWORD")
  ]

config :sentry,
  dsn: Environment.get("SENTRY_DSN"),
  environment_name: Environment.get("SENTRY_ENVIRONMENT_NAME"),
  included_environments: [Environment.get("SENTRY_ENVIRONMENT_NAME")]

config :new_relic_agent,
  app_name: System.get_env("NEW_RELIC_APP_NAME"),
  license_key: System.get_env("NEW_RELIC_LICENSE_KEY")
