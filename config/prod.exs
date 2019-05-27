use Mix.Config

# Configure Phoenix endpoint
config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

# Configure Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :info,
  metadata: ~w(request_id)a
