defmodule ElixirBoilerplate.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_boilerplate,
      version: "0.0.1",
      elixir: "~> 1.11",
      erlang: "~> 23.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: ["test"],
      test_pattern: "**/*_test.exs",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
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
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp deps do
    [
      # HTTP Client
      {:hackney, "~> 1.17"},

      # HTTP server
      {:plug_cowboy, "~> 2.5"},
      {:plug_canonical_host, "~> 2.0"},
      {:corsica, "~> 1.1"},

      # Phoenix
      {:phoenix, "~> 1.5.9"},
      {:phoenix_html, "~> 2.14.3"},
      {:phoenix_ecto, "~> 4.3"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:jason, "~> 1.2"},

      # GraphQL
      {:absinthe, "~> 1.5"},
      {:absinthe_plug, "~> 1.5"},
      {:dataloader, "~> 1.0"},
      {:absinthe_error_payload, "~> 1.1"},

      # Database
      {:ecto_sql, "~> 3.6"},
      {:postgrex, "~> 0.15"},

      # Translations
      {:gettext, "~> 0.18"},

      # Errors
      {:sentry, "~> 8.0"},

      # Monitoring
      {:new_relic_agent, "~> 1.23"},
      {:new_relic_phoenix, "~> 0.3"},
      {:new_relic_absinthe, "~> 0.0"},

      # Linting
      {:credo, "~> 1.5", only: [:dev, :test], override: true},
      {:credo_envvar, "~> 0.1", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 1.0", only: [:dev, :test], runtime: false},

      # Security check
      {:sobelow, "~> 0.11", only: [:dev, :test], runtime: true},
      {:mix_audit, "~> 0.1", only: [:dev, :test], runtime: false},

      # Health
      {:plug_checkup, "~> 0.6"},

      # Test factories
      {:ex_machina, "~> 2.6", only: :test},
      {:faker, "~> 0.16", only: :test},

      # Test coverage
      {:excoveralls, "~> 0.14", only: :test}
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
