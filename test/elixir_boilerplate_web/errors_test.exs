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
      field(:username, :string)
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
      |> validate_required(:username)
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

    assert html =~ "<li>email has invalid format[validation=:format]</li>"
    assert html =~ "<li>email should be %{count} character(s)[count=10,kind=:is,type=:string,validation=:length]</li>"
    assert html =~ "<li>multiple_roles.type can&#39;t be blank[validation=:required]</li>"
    assert html =~ "<li>nicknames should have at least %{count} item(s)[count=1,kind=:min,type=:list,validation=:length]</li>"
    assert html =~ "<li>single_role.type is invalid[enum=admin,moderator,member,validation=:inclusion]</li>"
  end

  defp changeset_to_error_messages(changeset) do
    changeset
    |> Errors.error_messages()
    |> Phoenix.HTML.safe_to_string()
  end
end
