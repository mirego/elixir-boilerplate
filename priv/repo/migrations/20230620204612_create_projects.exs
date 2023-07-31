defmodule ElixirBoilerplate.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string
      add :description, :string
      add :next_milestone_at, :utc_datetime_usec
      add :launch_at, :utc_datetime_usec

      timestamps()
    end
  end
end
