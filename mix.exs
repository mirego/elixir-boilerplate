defmodule ElixirBoilerplate.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_boilerplate,
      version: "0.0.1",
      elixir: "1.8.1",
      erlang: "21.3.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: ["test"],
      test_pattern: "**/*_test.exs",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      dialyzer: dialyzer(),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ElixirBoilerplate.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # HTTP server
      {:plug_cowboy, "~> 2.0"},
      {:plug_canonical_host, "~> 0.6"},

      # Phoenix
      {:phoenix, "~> 1.4.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:jason, "~> 1.0"},

      # Database
      {:ecto_sql, "~> 3.0"},
      {:postgrex, "~> 0.14"},

      # Authentication
      {:basic_auth, "~> 2.2"},

      # Translations
      {:gettext, "~> 0.16"},

      # Errors
      {:sentry, "~> 6.2"},

      # Linting
      {:credo, git: "https://github.com/mirego/credo", branch: "feature/add-consistency-filenames-check", only: [:dev, :test], override: true},
      {:credo_envvar, git: "https://github.com/remiprev/credo_envvar", branch: "feature/feature/add-support-for-nested-module-with-siblings", only: ~w(dev test)a, runtime: false},

      # OTP Release
      {:distillery, "~> 2.0"},

      # Test coverage
      {:excoveralls, "~> 0.10", only: :test},

      # Success typing
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "compile.app": ["erlang.check_version", "compile.app"]
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ex_unit, :mix],
      plt_add_deps: :app_tree,
      plt_file: {:no_warn, "priv/plts/elixir_boilerplate.plt"}
    ]
  end
end
