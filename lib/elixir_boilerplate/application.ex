defmodule ElixirBoilerplate.Application do
  @moduledoc """
  Main entry point of the app
  """

  use Application

  def start(_type, _args) do
    children = [
      ElixirBoilerplateWeb.Telemetry,
      ElixirBoilerplate.Repo,
      {Phoenix.PubSub, name: ElixirBoilerplate.PubSub},
      ElixirBoilerplateWeb.Endpoint,
      {TelemetryUI, ElixirBoilerplate.TelemetryUI.config()}
    ]

    Logger.add_handlers(:elixir_boilerplate)

    opts = [strategy: :one_for_one, name: ElixirBoilerplate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ElixirBoilerplateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
