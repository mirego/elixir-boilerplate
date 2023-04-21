defmodule ElixirBoilerplateGraphQL.Middleware.ErrorReporting do
  defmodule Error do
    defexception [:message]
  end

  def run(%{result: %{errors: errors}, source: source} = blueprint, options) when not is_nil(errors) do
    Sentry.capture_exception(
      %Error{
        message: "Invalid GraphQL response"
      },
      extra: %{
        operation_name: operation_name(Absinthe.Blueprint.current_operation(blueprint)),
        variables: Keyword.get(options, :variables, %{}),
        errors: errors,
        source: source
      }
    )

    {:ok, blueprint}
  end

  def run(blueprint, _) do
    {:ok, blueprint}
  end

  defp operation_name(nil), do: nil
  defp operation_name(operation), do: operation.name
end
