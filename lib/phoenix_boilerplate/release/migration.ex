defmodule PhoenixBoilerplate.Release.Migrations do
  @start_apps ~w(crypto ssl postgrex ecto)a
  @repos Application.get_env(:phoenix_boilerplate, :ecto_repos, [])

  def migrate do
    start_services()
    run_migrations()
    stop_services()
  end

  defp start_services do
    IO.puts("Starting dependencies…")
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts("Starting repos…")
    Enum.each(@repos, & &1.start_link(pool_size: 1))
  end

  defp stop_services do
    IO.puts("Success!")
    :init.stop()
  end

  defp run_migrations do
    Enum.each(@repos, &run_migrations_for/1)
  end

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    migrations_path = priv_path_for(app, repo, "migrations")

    IO.puts("Running migrations for #{app}")
    Ecto.Migrator.run(repo, migrations_path, :up, all: true)
  end

  defp priv_path_for(app, repo, filename) do
    priv_dir = "#{:code.priv_dir(app)}"

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    Path.join([priv_dir, repo_underscore, filename])
  end
end
