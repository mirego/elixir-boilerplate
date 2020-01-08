import Config

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :elixir_boilerplate, ElixirBoilerplateWeb, data_identity_provider: ElixirBoilerplateWeb.DataIdentifier.NoTestID

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :info,
  metadata: ~w(request_id)a
