defmodule ElixirBoilerplateGraphQL do
  alias Absinthe.Phase.Document.Result
  alias ElixirBoilerplateGraphQL.Middleware

  def configuration do
    [
      document_providers: [Absinthe.Plug.DocumentProvider.Default],
      json_codec: Phoenix.json_library(),
      schema: ElixirBoilerplateGraphQL.Schema,
      pipeline: {__MODULE__, :absinthe_pipeline}
    ]
  end

  def absinthe_pipeline(config, opts) do
    config
    |> Absinthe.Plug.default_pipeline(opts)
    |> Absinthe.Pipeline.insert_before(Result, Middleware.OperationNameLogger)
    |> Absinthe.Pipeline.insert_after(Result, Middleware.ErrorReporting)
  end
end
