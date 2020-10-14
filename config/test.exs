import Config

defmodule TestEnvironment do
  @database_name_suffix "_test"

  def get_database_url do
    url = Environment.get("DATABASE_URL")

    if is_nil(url) || String.ends_with?(url, @database_name_suffix) do
      url
    else
      raise "Expected database URL to end with '#{@database_name_suffix}', got: #{url}"
    end
  end
end

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  http: [port: 4001],
  server: false,
  secret_key_base: "G0ieeRljoXGzSDPRrYc2q4ADyNHCwxNOkw7YpPNMa+JgP9iGgJKT4K96Bw/Mf/pd",
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

config :elixir_boilerplate, ElixirBoilerplateWeb.Router,
  session_key: "test",
  session_signing_salt: "qh+vmMHsOqcjKF3TSSIsghwt2go48m2+IQ+kMTOB3BrSysSr7D4a21uAtt4yp4wn"

config :logger, level: :warn

config :elixir_boilerplate, ElixirBoilerplate.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: TestEnvironment.get_database_url()
