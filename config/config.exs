use Mix.Config

# Extract version from Mix
version = Mix.Project.config()[:version]

# Configure application
config :elixir_boilerplate,
  ecto_repos: [ElixirBoilerplate.Repo],
  version: version

# Configure Phoenix
config :phoenix, :json_library, Jason

# Configure Phoenix endpoint
config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  pubsub: [name: ElixirBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2],
  render_errors: [view: ElixirBoilerplateWeb.Errors.View, accepts: ~w(html json)]

# Configure Gettext
config :elixir_boilerplate, ElixirBoilerplate.Gettext, default_locale: "en"

# Configure Sentry
config :sentry,
  included_environments: [:prod],
  root_source_code_path: File.cwd!(),
  release: version

# Import runtime configuration
import_config "../rel/config/runtime.exs"

# Import environment configuration
import_config "#{Mix.env()}.exs"
