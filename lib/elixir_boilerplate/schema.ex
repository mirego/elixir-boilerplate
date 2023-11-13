defmodule ElixirBoilerplate.Schema do
  @moduledoc false
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      alias Ecto.Schema
      alias Ecto.UUID

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
