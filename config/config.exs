use Mix.Config

# Configure application
config :elixir_boilerplate, ecto_repos: [ElixirBoilerplate.Repo]

# Configure Phoenix
config :phoenix, :json_library, Jason

# Configure endpoint
config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint,
  pubsub: [name: ElixirBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2],
  render_errors: [view: ElixirBoilerplateWeb.Errors.View, accepts: ~w(html json)]

# Configure Gettext
config :elixir_boilerplate, ElixirBoilerplate.Gettext, default_locale: "en"

# Import runtime configuration
import_config "../rel/config/release.exs"

# Import environment configuration
import_config "#{Mix.env()}.exs"
