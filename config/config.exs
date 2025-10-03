import Config

version = Mix.Project.config()[:version]

config :absinthe_security, AbsintheSecurity.Phase.MaxAliasesCheck, max_alias_count: 100
config :absinthe_security, AbsintheSecurity.Phase.MaxDepthCheck, max_depth_count: 100
config :absinthe_security, AbsintheSecurity.Phase.MaxDirectivesCheck, max_directive_count: 100

config :elixir_boilerplate, Corsica, allow_headers: :all
config :elixir_boilerplate, ElixirBoilerplate.Gettext, default_locale: "en"

config :elixir_boilerplate, ElixirBoilerplate.Repo,
  migration_primary_key: [type: :binary_id, default: {:fragment, "gen_random_uuid()"}],
  migration_timestamps: [type: :utc_datetime_usec],
  start_apps_before_migration: [:ssl]

config :elixir_boilerplate, ElixirBoilerplateGraphQL, token_limit: 2000

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  pubsub_server: ElixirBoilerplate.PubSub,
  render_errors: [view: ElixirBoilerplateWeb.Errors, accepts: ~w(html json)]

config :elixir_boilerplate, ElixirBoilerplateWeb.Plugs.Security, allow_unsafe_scripts: false

config :elixir_boilerplate,
  ecto_repos: [ElixirBoilerplate.Repo],
  version: version

config :esbuild,
  version: "0.16.4",
  default: [
    args: ~w(js/app.ts --bundle --target=es2020 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :logger, backends: [:console, Sentry.LoggerBackend]

# Import environment configuration
config :phoenix, :json_library, Jason

config :sentry,
  root_source_code_path: File.cwd!(),
  release: version

import_config "#{Mix.env()}.exs"
