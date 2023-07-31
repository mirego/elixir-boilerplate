# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your repositories directly:
#
#     ElixirBoilerplate.Repo.insert!(%ElixirBoilerplate.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!` and so on) as they
# will fail if something goes wrong.

alias ElixirBoilerplate.Planning.{Project, Task}
alias ElixirBoilerplate.Repo

project =
  %Project{
    title: "TODOs",
    description: "A simple schema to showcase the way we are structuring our relational database data structures",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  }
  |> Repo.insert!()

_tasks =
  Repo.insert_all(Task, [
    [description: "A first task in the project;", project_id: project.id, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()],
    [description: "A second task", project_id: project.id, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()],
    [description: "And one last one…", project_id: project.id, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()]
  ])
