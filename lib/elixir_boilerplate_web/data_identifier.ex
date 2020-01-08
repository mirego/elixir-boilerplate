defmodule ElixirBoilerplateWeb.DataIdentifier do
  def testid_attribute(key), do: Application.get_env(:elixir_boilerplate, ElixirBoilerplateWeb)[:data_identity_provider].testid_attribute(key)
  def testid_key(key), do: Application.get_env(:elixir_boilerplate, ElixirBoilerplateWeb)[:data_identity_provider].testid_key(key)

  defmodule TestID do
    def testid_attribute(key) do
      {:safe, ~s(data-testid="#{key}")}
    end

    def testid_key(key), do: key
  end

  defmodule NoTestID do
    def testid_attribute(_), do: nil
    def testid_key(_), do: nil
  end
end
