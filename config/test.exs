import Config

# Import runtime configuration
import_config "releases.exs"

defmodule TestEnvironment do
  @database_name_suffix "_test"

  def enforce_test_database_name(key) do
    url = Environment.get_local_url(key)

    case String.contains?(url, @database_name_suffix) do
      true -> url
      _ -> raise "Expected database URL to ends with '#{@database_name_suffix}', got: #{url}"
    end
  end
end

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  http: [port: 4001],
  server: false,
  secret_key_base: "G0ieeRljoXGzSDPRrYc2q4ADyNHCwxNOkw7YpPNMa+JgP9iGgJKT4K96Bw/Mf/pd",
  session_key: "test",
  signing_salt: "qh+vmMHsOqcjKF3TSSIsghwt2go48m2+IQ+kMTOB3BrSysSr7D4a21uAtt4yp4wn",
  static_url: [
    scheme: "https",
    host: "example.com",
    port: "443"
  ],
  url: [
    scheme: "https",
    host: "example.",
    port: "443"
  ]

config :logger, level: :warn

config :elixir_boilerplate, ElixirBoilerplate.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: TestEnvironment.enforce_test_database_name("DATABASE_URL")
