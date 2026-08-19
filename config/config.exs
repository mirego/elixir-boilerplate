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
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ElixirBoilerplateWeb.Controllers.ErrorHTML, json: ElixirBoilerplateWeb.Controllers.ErrorJSON],
    layout: false
  ],
  live_view: [signing_salt: "m3V4R9a4"]

config :elixir_boilerplate,
  ecto_repos: [ElixirBoilerplate.Repo],
  version: version

config :esbuild,
  version: "0.25.4",
  elixir_boilerplate: [
    args: ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Import environment configuration
config :phoenix, :json_library, Jason

config :sentry,
  root_source_code_path: File.cwd!(),
  release: version

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.12",
  elixir_boilerplate: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

import_config "#{Mix.env()}.exs"
