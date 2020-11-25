defmodule ElixirBoilerplateWeb.ErrorsTest do
  use ElixirBoilerplate.DataCase, async: true

  alias ElixirBoilerplateWeb.Errors

  defmodule UserRole do
    use Ecto.Schema

    import Ecto.Changeset

    embedded_schema do
      field(:type, :string)

      timestamps()
    end

    def changeset(%__MODULE__{} = user_role, params) do
      user_role
      |> cast(params, [:type])
      |> validate_required([:type])
      |> validate_inclusion(:type, ~w(admin moderator member))
    end
  end

  defmodule User do
    use Ecto.Schema

    import Ecto.Changeset

    schema "users" do
      field(:email, :string)
      field(:nicknames, {:array, :string})

      embeds_one(:single_role, UserRole)
      embeds_many(:multiple_roles, UserRole)

      timestamps()
    end

    def changeset(%__MODULE__{} = user, params) do
      user
      |> cast(params, [:email, :nicknames])
      |> cast_embed(:single_role)
      |> cast_embed(:multiple_roles)
      |> validate_length(:email, is: 10)
      |> validate_length(:nicknames, min: 1)
      |> validate_format(:email, ~r/@/)
    end
  end

  test "error_messages/1 without errors should return an empty string" do
    html =
      %User{}
      |> change()
      |> changeset_to_error_messages()

    assert html == ""
  end

  test "error_messages/1 should render error messages on changeset" do
    html =
      %User{}
      |> User.changeset(%{"email" => "foo", "nicknames" => [], "single_role" => %{"type" => "bar"}, "multiple_roles" => [%{"type" => ""}]})
      |> changeset_to_error_messages()

    assert html =~ "<li>email has invalid format</li>"
    assert html =~ "<li>email should be 10 characters</li>"
    assert html =~ "<li>multiple_roles.type can’t be blank</li>"
    assert html =~ "<li>nicknames should have at least 1 item</li>"
    assert html =~ "<li>single_role.type is invalid</li>"
  end

  defp changeset_to_error_messages(changeset) do
    changeset
    |> Errors.error_messages()
    |> Phoenix.HTML.safe_to_string()
  end
end
