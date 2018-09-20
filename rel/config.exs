# Import all plugins from `rel/plugins`
~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/config/distillery.html

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"=6yFnxJ1$^TfFZsr2qrpqF}9QJdDuQ6grRN]w3X<iev:V4(f`|pm,/om,pd{{Nh4"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"DpMAf{x2V$>ienfo6J}PypRYo$&4&/S?%Jaup5?|>{mt>WO8/?wtq~N0&os)F!{E"
end

release :phoenix_boilerplate do
  set version: current_version(:phoenix_boilerplate)

  set applications: [
    :runtime_tools
  ]

  set config_providers: [
    {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
  ]

  set overlays: [
    {:copy, "rel/config/config.exs", "etc/config.exs"}
  ]

  set commands: [
    migrate: "rel/commands/migrate.sh",
  ]
end
