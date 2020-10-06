defmodule ElixirBoilerplate.Application do
  @moduledoc """
  Main entry point of the app
  """

  use Application

  def start(_type, _args) do
    children = [
      ElixirBoilerplate.Repo,
      {Phoenix.PubSub, [name: ElixirBoilerplate.PubSub, adapter: Phoenix.PubSub.PG2]},
      ElixirBoilerplateWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ElixirBoilerplate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ElixirBoilerplateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
