import Config

defmodule TestEnvironment do
  @moduledoc false
  @database_name_suffix "_test"

  def get_database_url do
    url = System.get_env("DATABASE_URL")

    if is_nil(url) || String.ends_with?(url, @database_name_suffix) do
      url
    else
      raise "Expected database URL to end with '#{@database_name_suffix}', got: #{url}"
    end
  end
end

# This config is to output keys instead of translated message in test
config :elixir_boilerplate, ElixirBoilerplate.Gettext, priv: "priv/null"

config :elixir_boilerplate, ElixirBoilerplate.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: TestEnvironment.get_database_url()

config :elixir_boilerplate, ElixirBoilerplateWeb.Endpoint, server: false

config :html_test_identifiers, provider: HTMLTestIdentifiers.TestID

config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Sort query params output of verified routes for robust url comparisons
config :phoenix,
  sort_verified_routes_query_params: true

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
