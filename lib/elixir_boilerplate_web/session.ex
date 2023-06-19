defmodule ElixirBoilerplateWeb.Session do
  @spec get_options() :: keyword()
  def get_options do
    [
      store: :cookie,
      key: Application.get_env(:elixir_boilerplate, __MODULE__)[:session_key],
      signing_salt: Application.get_env(:elixir_boilerplate, __MODULE__)[:session_signing_salt],
      secure: true
    ]
  end
end
