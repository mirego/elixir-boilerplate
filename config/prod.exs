import Config

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  debug_errors: false

config :elixir_boilerplate, :logger, [
  {:handler, :sentry_handler, Sentry.LoggerHandler,
   %{
     config: %{
       metadata: [:file, :line],
       rate_limiting: [max_events: 10, interval: _1_second = 1_000],
       capture_log_messages: true,
       level: :error
     }
   }}
]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :info,
  metadata: ~w(request_id graphql_operation_name)a
