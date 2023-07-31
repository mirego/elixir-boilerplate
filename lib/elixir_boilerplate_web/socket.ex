defmodule ElixirBoilerplateWeb.Socket do
  use Phoenix.Socket

  use Absinthe.Phoenix.Socket, schema: ElixirBoilerplateGraphQL.Schema

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
