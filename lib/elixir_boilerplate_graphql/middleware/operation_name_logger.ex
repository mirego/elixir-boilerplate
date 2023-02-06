defmodule ElixirBoilerplateGraphQL.Middleware.OperationNameLogger do
  @behaviour Absinthe.Middleware

  alias Absinthe.Blueprint.Document.Operation

  def call(resolution, _opts) do
    case Enum.find(resolution.path, &current_operation?/1) do
      %Operation{name: name} when not is_nil(name) ->
        Logger.metadata(graphql_operation_name: name)

      _ ->
        Logger.metadata(graphql_operation_name: "#NULL")
    end

    resolution
  end

  defp current_operation?(%Operation{current: true}), do: true
  defp current_operation?(_), do: false
end
