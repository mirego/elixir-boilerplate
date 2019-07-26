defmodule ElixirBoilerplateGraphQL.Application.Types do
  use Absinthe.Schema.Notation

  object :application do
    @desc "The application version"
    field(:version, :string)
  end

  object :application_queries do
    @desc "A list of application information"
    field :application, :application do
      resolve(fn _, _, _ -> {:ok, %{version: version()}} end)
    end
  end

  defp version, do: Application.get_env(:elixir_boilerplate, :version)
end
