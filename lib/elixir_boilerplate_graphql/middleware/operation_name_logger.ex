defmodule ElixirBoilerplateGraphQL.Middleware.OperationNameLogger do
  def run(blueprint, _opts) do
    operation_name = Absinthe.Blueprint.current_operation(blueprint).name || "#NULL"
    Logger.metadata(graphql_operation_name: operation_name)

    {:ok, blueprint}
  end
end
