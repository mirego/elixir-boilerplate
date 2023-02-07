import Config

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  code_reloader: true,
  check_origin: false,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/elixir_boilerplate_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :elixir_boilerplate, ElixirBoilerplateWeb.Plugs.Security, allow_unsafe_scripts: true

config :elixir_boilerplate, ElixirBoilerplateGraphQL, enable_introspection: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

# Enable dev routes for dashboard and mailbox
config :elixir_boilerplate, dev_routes: true
