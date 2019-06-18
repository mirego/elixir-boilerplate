defmodule Mix.Tasks.Check.UnusedLockedDeps do
  use Mix.Task

  @shortdoc "Check if there are unused locked dependencies"

  @impl true
  def run(_) do
    used_apps =
      []
      |> Mix.Dep.load_on_environment()
      |> Enum.map(& &1.app)
      |> MapSet.new()

    locked_apps =
      Mix.Dep.Lock.read()
      |> Map.keys()
      |> MapSet.new()

    used_locked_apps = MapSet.intersection(used_apps, locked_apps)

    unused_locked_apps =
      locked_apps
      |> MapSet.difference(used_locked_apps)
      |> MapSet.to_list()

    if unused_locked_apps != [] do
      apps = Enum.map_join(unused_locked_apps, "\n", &"  #{&1}")

      Mix.raise("There are some unused dependencies in the lockfile. Run `mix deps.unlock --unused` to unlock them.\n#{apps}")
    end
  end
end
