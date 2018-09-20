use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_boilerplate, PhoenixBoilerplate.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure Repo with a sandboxed Postgres
config :phoenix_boilerplate, PhoenixBoilerplate.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool: Ecto.Adapters.SQL.Sandbox
