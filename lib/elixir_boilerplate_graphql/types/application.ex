defmodule ElixirBoilerplateGraphQL.Types.Application do
  use Absinthe.Schema.Notation

  # Types
  object :application_info do
    @desc "The application version"
    field(:version, :string)
  end

  # Queries
  object :application_queries do
    @desc "A list of application information"
    field :application, :application_info do
      resolve(fn _, _, _ -> {:ok, %{version: version()}} end)
    end
  end

  defp version, do: Application.get_env(:elixir_boilerplate, :version)
end
