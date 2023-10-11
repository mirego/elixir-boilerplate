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
      <svg height="64" viewBox="0 0 64 64" width="64" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><linearGradient id="a" gradientTransform="matrix(.12970797 0 0 .19997863 11.409779 -.000001)" gradientUnits="userSpaceOnUse" x1="167.51685" x2="160.31" y1="24.393208" y2="320.03421"><stop offset="0" stop-color="#d9d8dc"/><stop offset="1" stop-color="#fff" stop-opacity=".385275"/></linearGradient><linearGradient id="b" gradientTransform="matrix(.11420937 0 0 .22711641 11.409779 -.000001)" gradientUnits="userSpaceOnUse" x1="199.03606" x2="140.0712" y1="21.412943" y2="278.40781"><stop offset="0" stop-color="#8d67af" stop-opacity=".671932"/><stop offset="1" stop-color="#9f8daf"/></linearGradient><linearGradient id="c" gradientTransform="matrix(.12266694 0 0 .21145732 11.409779 -.000001)" gradientUnits="userSpaceOnUse" x1="206.42825" x2="206.42825" y1="100.91758" y2="294.31174"><stop offset="0" stop-color="#26053d" stop-opacity=".761634"/><stop offset="1" stop-color="#b7b4b4" stop-opacity=".277683"/></linearGradient><linearGradient id="d" gradientTransform="matrix(.18477958 0 0 .14037711 11.409779 -.000001)" gradientUnits="userSpaceOnUse" x1="23.483095" x2="112.93069" y1="171.71753" y2="351.72263"><stop offset="0" stop-color="#91739f" stop-opacity=".45955"/><stop offset="1" stop-color="#32054f" stop-opacity=".539912"/></linearGradient><linearGradient id="e" gradientTransform="matrix(.14183937 0 0 .18287462 11.409779 -.000001)" gradientUnits="userSpaceOnUse" x1="226.7811" x2="67.803513" y1="317.25201" y2="147.4131"><stop offset="0" stop-color="#463d49" stop-opacity=".331182"/><stop offset="1" stop-color="#340a50" stop-opacity=".821388"/></linearGradient><linearGradient id="f" gradientTransform="matrix(.10596912 0 0 .24477717 11.409779 -.000001)" gradientUnits="userSpaceOnUse" x1="248.0164" x2="200.70529" y1="88.755211" y2="255.00513"><stop offset="0" stop-color="#715383" stop-opacity=".145239"/><stop offset="1" stop-color="#f4f4f4" stop-opacity=".233639"/></linearGradient><linearGradient id="g" gradientTransform="matrix(.09173097 0 0 .28277061 11.409779 -.000001)" gradientUnits="userSpaceOnUse" x1="307.5639" x2="156.45103" y1="109.963" y2="81.526764"><stop offset="0" stop-color="#a5a1a8" stop-opacity=".356091"/><stop offset="1" stop-color="#370c50" stop-opacity=".581975"/></linearGradient><g fill-rule="evenodd"><path d="m34.033696.16105439c-4.649706 1.64813521-9.138214 6.45860111-13.465525 14.43139761-6.490966 11.959195-14.8743608 28.953434-3.330358 42.408733 5.340603 6.224826 14.158605 9.898679 25.730911 4.080095 9.296536-4.67432 11.882014-18.088489 8.544419-24.392035-6.884785-13.002951-13.869705-16.210096-15.740131-24.273959-1.24695-5.375909-1.826722-9.4606528-1.739316-12.25423161z" fill="url(#a)"/><path d="m34.033696-.00000095c-4.673294 1.66512615-9.161803 6.47559215-13.465525 14.43139795-6.455581 11.933709-14.8743608 28.953433-3.330358 42.408733 5.340603 6.224826 14.045121 8.236341 18.875071 4.544505 3.148725-2.40677 5.290239-4.700935 6.52406-9.534696 1.373834-5.382292.319746-12.628547-.402523-15.957361-.913952-4.212248-1.213096-8.835494-.897429-13.869735-.11123-.135513-.194345-.236927-.249347-.30424-2.514528-3.077324-4.454883-5.757778-5.314633-9.464373-1.24695-5.3759083-1.826722-9.4606522-1.739316-12.25423095z" fill="url(#b)"/><path d="m30.164134 2.0937185c-4.352812 3.440161-7.589227 9.2104935-9.709246 17.3109975-3.180029 12.150756-3.524621 23.355714-2.403077 29.873065 2.17418 12.634271 13.445838 17.430108 25.007417 11.549319 7.115151-3.619115 10.078654-11.387504 9.921651-19.81976-.162566-8.731042-17.034649-18.626155-20.022678-25.912745-1.992018-4.857728-2.923374-9.1913529-2.794067-13.0008765z" fill="url(#c)"/><path d="m41.199436 24.874043c5.220347 6.694959 6.358283 11.355459 3.413807 13.981497-4.416714 3.93906-15.217419 6.509155-21.936599 1.744215-4.479454-3.176628-6.174316-9.991206-5.084588-20.443737-1.849118 3.861723-3.412567 7.773671-4.690348 11.735849-1.27778 3.962178-1.650915 8.108529-1.119404 12.439052 1.601351 3.239683 5.494817 5.403396 11.680397 6.491139 9.278371 1.631615 18.060122.825407 23.95271-2.145065 3.928391-1.980314 5.786494-3.951651 5.574312-5.91401.141766-2.897853-.751847-5.656438-2.680832-8.275753-1.928988-2.619317-4.965472-5.823713-9.109455-9.613187z" fill="url(#d)"/><path d="m20.799251 18.189006c-.04364 4.835125 1.199603 9.431489 3.729718 13.789093 3.795174 6.536405 8.225212 12.995204 14.854367 18.348954 4.419436 3.569167 7.950747 4.722294 10.593929 3.459382-2.170994 3.88538-4.479397 5.78925-6.925211 5.711609-3.668718-.11646-8.142117-1.719788-15.309635-10.333032-4.778347-5.742163-8.047222-11.17387-9.806624-16.295121.279004-2.031676.574857-4.055285.887559-6.070826.312702-2.015542.971335-4.885561 1.975897-8.610059z" fill="url(#e)"/><path d="m32.011273 24.824412c.405511 3.938827 1.93822 10.239557 0 14.434591-1.938221 4.195036-10.890677 11.773476-8.419446 18.449432 2.47123 6.675957 8.493644 5.177168 12.271355 2.100547 3.777712-3.076623 5.799822-8.079349 6.248034-11.597523.448213-3.518171-1.072381-10.287708-1.56693-16.17596-.329698-3.9255-.106002-7.291185.671093-10.097054l-1.15758-1.456665-6.813456-2.017361c-1.092388 1.614111-1.503411 3.73411-1.23307 6.359993z" fill="url(#f)"/><path d="m34.443394 5.3148253c-2.205235.9318217-4.294586 2.7781986-6.268054 5.5391307-2.960203 4.141399-4.467906 6.623907-3.3519 14.833191.744003 5.472857 1.276531 10.50778 1.597582 15.104773l9.543032-27.726988c-.350835-1.412815-.642632-2.688766-.875391-3.8278548-.232758-1.1390887-.447848-2.446506-.645269-3.9222519z" fill="url(#g)"/><path d="m35.945755 13.009805c-2.422551 1.413992-4.299708 4.310913-5.631469 8.690763-1.331762 4.379852-2.550147 10.50277-3.655157 18.368756 1.47381-5.003069 2.451455-8.626771 2.932936-10.871105.722221-3.366501.968912-8.127131 2.886564-11.359156 1.278437-2.154684 2.434144-3.764436 3.467126-4.829258z" fill="#330a4c" fill-opacity=".316321"/><path d="m24.728788 59.937995c3.986659.569558 6.071303 1.075916 6.253931 1.519073.273942.664733-.504655 1.272785-2.717611.864177-1.475304-.272404-2.654077-1.06682-3.53632-2.38325z" fill="#fff"/><path d="m26.731652 5.3148253c-2.192807 2.6195801-4.092897 5.3967527-5.700271 8.3315187s-2.755892 5.124204-3.445555 6.568313c-.213753 1.077096-.318084 2.666371-.312993 4.767823.0051 2.101452.186856 4.438039.545295 7.009761.313817-5.035952 1.274508-9.924178 2.882072-14.664678 1.607565-4.740501 3.618049-8.7447464 6.031452-12.0127377z" fill="#ededed" fill-opacity=".603261"/></g></svg>
      """
      # logo: """
      #   <svg height="100" width="100"><circle cx="50" cy="50" r="40" stroke-width="3" fill="#8549a7" /></svg>
      # """
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
