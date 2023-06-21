defmodule ElixirBoilerplate.Planning.Project do
  use ElixirBoilerplate.Schema

  schema "projects" do
    field :description, :string
    field :launch_at, :naive_datetime
    field :next_milestone_at, :naive_datetime
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, ~w[title description next_milestone_at launch_at]a)
    |> validate_required(~w[title description]a)
  end
end
