defmodule ElixirBoilerplate.Planning.Task do
  use ElixirBoilerplate.Schema

  alias ElixirBoilerplate.Planning.Project

  schema "tasks" do
    field :description, :string
    field :priority, :integer
    field :due_at, :utc_datetime_usec

    belongs_to :project, Project

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, ~w[project_id description priority due_at]a)
    |> validate_required(~w[project_id description]a)
  end
end
