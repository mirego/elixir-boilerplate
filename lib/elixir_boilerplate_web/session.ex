defmodule ElixirBoilerplateWeb.Session do
  @moduledoc false
  def config do
    [
      store: :cookie,
      key: app_config(:session_key),
      signing_salt: app_config(:session_signing_salt)
    ]
  end

  defp app_config(key) do
    Keyword.fetch!(Application.get_env(:elixir_boilerplate, ElixirBoilerplateWeb.Endpoint), key)
  end
end
