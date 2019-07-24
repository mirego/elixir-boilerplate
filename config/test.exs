import Config

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  http: [port: 4001],
  server: false,
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

config :elixir_boilerplate, ElixirBoilerplate.Repo, pool: Ecto.Adapters.SQL.Sandbox

# Import runtime configuration
import_config "releases.exs"
