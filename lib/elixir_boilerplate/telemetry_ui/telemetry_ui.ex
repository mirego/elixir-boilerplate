defmodule ElixirBoilerplate.TelemetryUI do
  @moduledoc false
  import TelemetryUI.Metrics

  def config do
    ui_options = [metrics_class: "grid-cols-8 gap-4"]

    [
      metrics: [
        {"HTTP", http_metrics(), ui_options: ui_options},
        {"GraphQL", graphql_metrics(), ui_options: [metrics_class: "grid-cols-8 gap-4"]},
        {"Absinthe", absinthe_metrics(), ui_options: [metrics_class: "grid-cols-8 gap-4"]},
        {"Ecto", ecto_metrics(), ui_options: ui_options},
        {"System", system_metrics()}
      ],
      theme: theme(),
      backend: backend()
    ]
  end

  def http_metrics do
    http_keep = &(&1[:route] not in ~w(/metrics))

    [
      counter("phoenix.router_dispatch.stop.duration",
        description: "Number of requests",
        keep: http_keep,
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-3", unit: " requests"]
      ),
      count_over_time("phoenix.router_dispatch.stop.duration",
        description: "Number of requests over time",
        keep: http_keep,
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-5", unit: " requests"]
      ),
      average("phoenix.router_dispatch.stop.duration",
        description: "Requests duration",
        keep: http_keep,
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-3", unit: " ms"]
      ),
      average_over_time("phoenix.router_dispatch.stop.duration",
        description: "Requests duration over time",
        keep: http_keep,
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-5", unit: " ms"]
      ),
      count_over_time("phoenix.router_dispatch.stop.duration",
        description: "HTTP requests count per route",
        keep: http_keep,
        tags: [:route],
        unit: {:native, :millisecond},
        ui_options: [unit: " requests"],
        reporter_options: [class: "col-span-4"]
      ),
      counter("phoenix.router_dispatch.stop.duration",
        description: "Count HTTP requests by route",
        keep: http_keep,
        tags: [:route],
        unit: {:native, :millisecond},
        ui_options: [unit: " requests"],
        reporter_options: [class: "col-span-4"]
      ),
      average_over_time("phoenix.router_dispatch.stop.duration",
        description: "HTTP requests duration per route",
        keep: http_keep,
        tags: [:route],
        unit: {:native, :millisecond},
        reporter_options: [class: "col-span-4"]
      ),
      distribution("phoenix.router_dispatch.stop.duration",
        description: "Requests duration",
        keep: http_keep,
        unit: {:native, :millisecond},
        reporter_options: [buckets: [0, 100, 500, 2000]]
      )
    ]
  end

  defp ecto_metrics do
    ecto_keep = &(&1[:source] not in [nil, ""] and not String.starts_with?(&1[:source], "oban") and not String.starts_with?(&1[:source], "telemetry_ui"))

    [
      average("elixir_boilerplate.repo.query.total_time",
        description: "Database query total time",
        keep: ecto_keep,
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-3", unit: " ms"]
      ),
      average_over_time("elixir_boilerplate.repo.query.total_time",
        description: "Database query total time over time",
        keep: ecto_keep,
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-5", unit: " ms"]
      ),
      average("elixir_boilerplate.repo.query.total_time",
        description: "Database query total time per source",
        keep: ecto_keep,
        tags: [:source],
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-full", unit: " ms"]
      )
    ]
  end

  defp absinthe_metrics do
    absinthe_tag_values = fn metadata ->
      operation_name =
        metadata.blueprint.operations
        |> Enum.map(& &1.name)
        |> Enum.uniq()
        |> Enum.join(",")

      %{operation_name: operation_name}
    end

    [
      average("absinthe.execute.operation.stop.duration",
        description: "Absinthe operation duration",
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-3", unit: " ms"]
      ),
      average_over_time("absinthe.execute.operation.stop.duration",
        description: "Absinthe operation duration over time",
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-5", unit: " ms"]
      ),
      counter("absinthe.execute.operation.stop.duration",
        description: "Count Absinthe executions per operation",
        tags: [:operation_name],
        tag_values: absinthe_tag_values,
        unit: {:native, :millisecond}
      ),
      average_over_time("absinthe.execute.operation.stop.duration",
        description: "Absinthe duration per operation",
        tags: [:operation_name],
        tag_values: absinthe_tag_values,
        unit: {:native, :millisecond}
      )
    ]
  end

  defp graphql_metrics do
    graphql_keep = &(&1[:route] in ~w(/graphql))

    graphql_tag_values = fn metadata ->
      operation_name =
        case metadata.conn.params do
          %{"_json" => json} ->
            json
            |> Enum.map(& &1["operationName"])
            |> Enum.uniq()
            |> Enum.join(",")

          _ ->
            nil
        end

      %{operation_name: operation_name}
    end

    [
      counter("graphql.router_dispatch.duration",
        event_name: [:phoenix, :router_dispatch, :stop],
        description: "Number of GraphQL requests",
        keep: graphql_keep,
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-3", unit: " requests"]
      ),
      count_over_time("graphql.router_dispatch.duration",
        event_name: [:phoenix, :router_dispatch, :stop],
        description: "Number of GraphQL requests over time",
        keep: graphql_keep,
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-5", unit: " requests"]
      ),
      average("graphql.router_dispatch.duration",
        event_name: [:phoenix, :router_dispatch, :stop],
        description: "GraphQL requests duration",
        keep: graphql_keep,
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-3", unit: " ms"]
      ),
      average_over_time("graphql.router_dispatch.duration",
        event_name: [:phoenix, :router_dispatch, :stop],
        description: "GraphQL requests duration over time",
        keep: graphql_keep,
        unit: {:native, :millisecond},
        ui_options: [class: "col-span-5", unit: " ms"]
      ),
      count_over_time("graphql.router_dispatch.duration",
        event_name: [:phoenix, :router_dispatch, :stop],
        description: "GraphQL requests count per operation",
        keep: graphql_keep,
        tag_values: graphql_tag_values,
        tags: [:operation_name],
        unit: {:native, :millisecond},
        ui_options: [unit: " requests"],
        reporter_options: [class: "col-span-4"]
      ),
      counter("graphql.router_dispatch.duration",
        event_name: [:phoenix, :router_dispatch, :stop],
        description: "Count GraphQL requests by operation",
        keep: graphql_keep,
        tag_values: graphql_tag_values,
        tags: [:operation_name],
        unit: {:native, :millisecond},
        ui_options: [unit: " requests"],
        reporter_options: [class: "col-span-4"]
      ),
      average("graphql.router_dispatch.duration",
        event_name: [:phoenix, :router_dispatch, :stop],
        description: "GraphQL requests duration per operation",
        keep: graphql_keep,
        tag_values: graphql_tag_values,
        tags: [:operation_name],
        unit: {:native, :millisecond},
        reporter_options: [class: "col-span-4"]
      ),
      distribution("graphql.router_dispatch.duration",
        event_name: [:phoenix, :router_dispatch, :stop],
        description: "GraphQL requests duration",
        keep: graphql_keep,
        unit: {:native, :millisecond},
        reporter_options: [buckets: [0, 100, 500, 2000]]
      )
    ]
  end

  defp system_metrics do
    [
      last_value("vm.memory.total", unit: {:byte, :megabyte})
    ]
  end

  defp theme do
    %{
      header_color: "#deb7ff",
      primary_color: "#8549a7",
      title: "ElixirBoilerplate",
      share_key: share_key(),
      logo: """
        <svg width="64" height="64" viewBox="0 0 266 266" xmlns="http://www.w3.org/2000/svg"><g fill-rule="nonzero" fill="none"><circle fill="#7F4BCB" cx="133" cy="133" r="133"/><path d="M135.08 60.197c-1.29-1.596-3.87-1.596-5.16 0C118.956 74.247 78 129.17 78 155.035 78 184.732 102.509 209 132.5 209s54.5-24.268 54.5-53.965c0-25.865-40.956-80.788-51.92-94.838Zm15.802 129.963c-.645.32-1.29.32-1.935.32-1.935 0-3.87-1.278-4.515-2.874-.968-2.555.322-5.11 2.58-6.387 19.026-7.663 17.414-30.654 17.092-30.974-.323-2.554 1.612-5.109 4.514-5.109 2.58-.32 5.16 1.597 5.16 4.47 1.29 10.219-2.58 32.252-22.896 40.554Z" fill="#3A186A"/></g></svg>
      """
    }
  end

  defp backend do
    %TelemetryUI.Backend.EctoPostgres{
      repo: ElixirBoilerplate.Repo,
      pruner_threshold: [months: -1],
      pruner_interval_ms: 84_000,
      max_buffer_size: 10_000,
      flush_interval_ms: 30_000,
      verbose: false
    }
  end

  defp share_key, do: Application.get_env(:elixir_boilerplate, __MODULE__)[:share_key]
end
