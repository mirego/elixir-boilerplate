defmodule ElixirBoilerplateGraphQL.OperationNameLogger do
  @behaviour Absinthe.Middleware

  def call(resolution, _opts) do
    with %Absinthe.Blueprint.Document.Operation{name: name} <- Enum.find(resolution.path, &current_operation?/1) do
      Logger.metadata(graphql_operation_name: name)
    end

    resolution
  end

  defp current_operation?(%Absinthe.Blueprint.Document.Operation{current: true}), do: true
  defp current_operation?(_), do: false
end
