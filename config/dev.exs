import Config

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  code_reloader: true,
  debug_errors: true,
  check_origin: false,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:elixir_boilerplate, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:elixir_boilerplate, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r{priv/gettext/.*$},
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{lib/elixir_boilerplate_web/.*(ee?x)$}
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :elixir_boilerplate, dev_routes: true

config :html_test_identifiers, provider: HTMLTestIdentifiers.TestID

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :plug_init_mode, :runtime
config :phoenix, :stacktrace_depth, 20
