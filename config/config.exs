import Config

version = Mix.Project.config()[:version]

config :elixir_boilerplate,
  ecto_repos: [ElixirBoilerplate.Repo],
  version: version

config :phoenix, :json_library, Jason

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  pubsub: [name: ElixirBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2],
  render_errors: [view: ElixirBoilerplateWeb.Errors.View, accepts: ~w(html json)]

config :elixir_boilerplate, ElixirBoilerplate.Repo, start_apps_before_migration: [:ssl]

config :elixir_boilerplate, Corsica, allow_headers: :all

config :elixir_boilerplate, ElixirBoilerplate.Gettext, default_locale: "en"

config :elixir_boilerplate, ElixirBoilerplateWeb.ContentSecurityPolicy, allow_unsafe_scripts: false

config :sentry,
  included_environments: ~w(prod)a,
  root_source_code_path: File.cwd!(),
  release: version

# Import environment configuration
import_config "#{Mix.env()}.exs"
