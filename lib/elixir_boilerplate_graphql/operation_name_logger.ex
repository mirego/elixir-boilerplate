defmodule ElixirBoilerplateGraphQL.OperationNameLogger do
  @behaviour Absinthe.Middleware

  alias Absinthe.Blueprint.Document.Operation

  def call(resolution, _opts) do
    with %Operation{name: name} when not is_nil(name) <- Enum.find(resolution.path, &current_operation?/1) do
      Logger.metadata(graphql_operation_name: name)
    else
      _ -> Logger.metadata(graphql_operation_name: "#NULL")
    end

    resolution
  end

  defp current_operation?(%Operation{current: true}), do: true
  defp current_operation?(_), do: false
end
