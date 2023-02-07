import Config

version = Mix.Project.config()[:version]

config :elixir_boilerplate,
  ecto_repos: [ElixirBoilerplate.Repo],
  version: version

config :phoenix, :json_library, Jason

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  pubsub_server: ElixirBoilerplate.PubSub,
  render_errors: [
    formats: [html: SampleAppWeb.ErrorHTML, json: SampleAppWeb.ErrorJSON],
    layout: false
  ]

config :elixir_boilerplate, ElixirBoilerplate.Repo, start_apps_before_migration: [:ssl]

config :elixir_boilerplate, Corsica, allow_headers: :all

config :elixir_boilerplate, ElixirBoilerplate.Gettext, default_locale: "en"

config :elixir_boilerplate, ElixirBoilerplateWeb.Plus.Security, allow_unsafe_scripts: false

config :elixir_boilerplate, ElixirBoilerplateGraphQL, enable_introspection: false

config :esbuild,
  version: "0.16.4",
  default: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :sentry,
  root_source_code_path: File.cwd!(),
  release: version

config :logger, backends: [:console, Sentry.LoggerBackend]

# Import environment configuration
import_config "#{Mix.env()}.exs"
