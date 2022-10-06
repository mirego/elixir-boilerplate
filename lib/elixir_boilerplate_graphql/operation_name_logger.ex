defmodule ElixirBoilerplateGraphQL.OperationNameLogger do
  @behaviour Absinthe.Middleware

  def call(resolution, _opts) do
    current_operation = Enum.find(resolution.path, &current_operation?/1)

    Logger.metadata(graphql_operation_name: current_operation.name)

    resolution
  end

  defp current_operation?(%Absinthe.Blueprint.Document.Operation{current: true}), do: true
  defp current_operation?(_), do: false
end
