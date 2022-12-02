defmodule ElixirBoilerplate.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_boilerplate,
      version: "0.0.1",
      erlang: "~> 25.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: ["test"],
      test_pattern: "**/*_test.exs",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer(),
      releases: releases()
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

  defp aliases do
    [
      "assets.deploy": [
        "esbuild default --minify",
        "phx.digest"
      ],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp deps do
    [
      # Assets bundling
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},

      # HTTP Client
      {:hackney, "~> 1.18"},

      # HTTP server
      {:plug_cowboy, "~> 2.6"},
      {:plug_canonical_host, "~> 2.0"},
      {:corsica, "~> 1.3"},

      # Phoenix
      {:phoenix, "~> 1.6"},
      {:phoenix_html, "~> 3.2"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:jason, "~> 1.2"},

      # GraphQL
      {:absinthe, "~> 1.7"},
      {:absinthe_plug, "~> 1.5"},
      {:dataloader, "~> 1.0"},
      {:absinthe_error_payload, "~> 1.1"},

      # Database
      {:ecto_sql, "~> 3.8"},
      {:postgrex, "~> 0.16"},

      # Translations
      {:gettext, "~> 0.20"},

      # Errors
      {:sentry, "~> 8.0"},

      # Monitoring
      {:new_relic_agent, "~> 1.27"},
      {:new_relic_absinthe, "~> 0.0"},

      # Linting
      {:credo, "~> 1.6", only: [:dev, :test], override: true},
      {:credo_envvar, "~> 0.1", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 2.0", only: [:dev, :test], runtime: false},

      # Security check
      {:sobelow, "~> 0.11", only: [:dev, :test], runtime: true},
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false},

      # Health
      {:plug_checkup, "~> 0.6"},

      # Test factories
      {:ex_machina, "~> 2.7", only: :test},
      {:faker, "~> 0.17", only: :test},

      # Test coverage
      {:excoveralls, "~> 0.15", only: :test},

      # Dialyzer
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end

  defp dialyzer do
    [
      plt_file: {:no_warn, "priv/plts/elixir_boilerplate.plt"},
      plt_add_apps: [:mix, :ex_unit]
    ]
  end

  defp releases do
    [
      elixir_boilerplate: [
        version: {:from_app, :elixir_boilerplate},
        applications: [elixir_boilerplate: :permanent],
        include_executables_for: [:unix],
        steps: [:assemble, :tar]
      ]
    ]
  end
end
