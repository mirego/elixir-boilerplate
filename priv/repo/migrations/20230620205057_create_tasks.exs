defmodule ElixirBoilerplate.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :project_id, references(:projects), null: false
      add :description, :string
      add :priority, :integer
      add :due_at, :utc_datetime_usec

      timestamps()
    end
  end
end
