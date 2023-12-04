defmodule ElixirBoilerplateGraphQL do
  @moduledoc false

  alias Absinthe.Phase.Document.Result
  alias Absinthe.Pipeline
  alias ElixirBoilerplateGraphQL.Middleware

  def configuration do
    [
      document_providers: [Absinthe.Plug.DocumentProvider.Default],
      json_codec: Phoenix.json_library(),
      schema: ElixirBoilerplateGraphQL.Schema,
      pipeline: {__MODULE__, :absinthe_pipeline}
    ]
  end

  def absinthe_pipeline(config, options) do
    options = build_options(options)

    config
    |> Absinthe.Plug.default_pipeline(options)
    |> Pipeline.insert_before(Result, Middleware.OperationNameLogger)
    |> Pipeline.insert_after(Result, Middleware.ErrorReporting)
  end

  defp build_options(options) do
    Keyword.merge(
      [
        token_limit: Application.get_env(:elixir_boilerplate, ElixirBoilerplateGraphQL)[:token_limit]
      ],
      Pipeline.options(options)
    )
  end
end
