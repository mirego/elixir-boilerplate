import Config

defmodule Environment do
  @moduledoc """
  This modules provides various helpers to handle environment metadata
  """

  def get(key, opts \\ []) do
    optional = Keyword.get(opts, :optional, false)

    case {System.get_env(key), optional, Mix.env()} do
      {nil, false, env} when env != :test -> raise("The application cannot start without a value for the `#{key}` environment variable.")
      {value, _, _} -> value
    end
  end

  def get_boolean(key, opts \\ []) do
    case get(key, opts) do
      "true" -> true
      "1" -> true
      _ -> false
    end
  end

  def get_integer(key, opts \\ []) do
    case get(key, opts) do
      value when is_bitstring(value) -> String.to_integer(value)
      _ -> nil
    end
  end

  def get_list_or_first_value(key, opts \\ []) do
    with value when is_bitstring(value) <- get(key, opts),
         [single_value] <- String.split(value, ",") do
      single_value
    else
      value when is_list(value) -> value
      _ -> nil
    end
  end
end

force_ssl = Environment.get_boolean("FORCE_SSL")
scheme = if force_ssl, do: "https", else: "http"
host = Environment.get("CANONICAL_HOST")
port = Environment.get("PORT")

config :elixir_boilerplate,
  canonical_host: host,
  force_ssl: force_ssl

config :elixir_boilerplate, ElixirBoilerplate.Repo,
  pool_size: Environment.get_integer("DATABASE_POOL_SIZE"),
  ssl: Environment.get_boolean("DATABASE_SSL"),
  url: Environment.get("DATABASE_URL")

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  debug_errors: Environment.get_boolean("DEBUG_ERRORS"),
  http: [port: port],
  secret_key_base: Environment.get("SECRET_KEY_BASE"),
  session_key: Environment.get("SESSION_KEY"),
  signing_salt: Environment.get("SIGNING_SALT"),
  static_url: [
    scheme: Environment.get("STATIC_URL_SCHEME", optional: true),
    host: Environment.get("STATIC_URL_HOST", optional: true),
    port: Environment.get("STATIC_URL_PORT", optional: true)
  ],
  url: [scheme: scheme, host: host, port: port]

config :elixir_boilerplate, Corsica, origins: Environment.get_list_or_first_value("CORS_ALLOWED_ORIGINS")

config :elixir_boilerplate,
  basic_auth: [
    username: Environment.get("BASIC_AUTH_USERNAME", optional: true),
    password: Environment.get("BASIC_AUTH_PASSWORD", optional: true)
  ]

config :sentry,
  dsn: Environment.get("SENTRY_DSN", optional: true),
  environment_name: Environment.get("SENTRY_ENVIRONMENT_NAME", optional: true)
