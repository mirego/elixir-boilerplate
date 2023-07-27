defmodule ElixirBoilerplate.Planning do
  alias ElixirBoilerplate.Planning.Project
  alias ElixirBoilerplate.Repo

  import Ecto.Query

  def list() do
    projects =
      queryable()
      |> Repo.all()

    {:ok, projects}
  end

  def get(project_id) do
    project =
      queryable()
      |> where(id: ^project_id)
      |> Repo.one()

    {:ok, project}
  end

  defp queryable() do
    from(p in Project,
      join: t in assoc(p, :tasks),
      order_by: [asc: field(t, :priority)],
      preload: [tasks: t]
    )
  end
end
