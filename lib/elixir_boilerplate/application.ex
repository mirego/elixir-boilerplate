defmodule ElixirBoilerplate.Application do
  @moduledoc """
  Main entry point of the app
  """

  use Application

  def start(_type, _args) do
    children = [
      ElixirBoilerplate.Repo,
      ElixirBoilerplateWeb.Endpoint
    ]

    {:ok, _} = Logger.add_backend(Sentry.LoggerBackend)

    opts = [strategy: :one_for_one, name: ElixirBoilerplate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ElixirBoilerplateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
