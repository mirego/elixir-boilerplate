defmodule ElixirBoilerplate.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :elixir_boilerplate,
      version: @version,
      elixir: "~> 1.9",
      erlang: "~> 22.0",
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
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "compile.app": ["check.erlang_version", "compile.app"]
    ]
  end

  defp deps do
    [
      # HTTP server
      {:plug_cowboy, "~> 2.1"},
      {:plug_canonical_host, "~> 1.0"},
      {:corsica, "~> 1.1"},

      # Phoenix
      {:phoenix, "~> 1.4.10"},
      {:phoenix_html, "~> 2.13.3"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:jason, "~> 1.1"},

      # GraphQL
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:dataloader, "~> 1.0"},
      {:absinthe_error_payload, "~> 1.0"},

      # Database
      {:ecto_sql, "~> 3.2"},
      {:postgrex, "~> 0.15"},

      # Authentication
      {:basic_auth, "~> 2.2"},

      # Translations
      {:gettext, "~> 0.16"},

      # Errors
      {:sentry, "~> 7.1"},

      # Linting
      {:credo, "~> 1.1", only: [:dev, :test], override: true},
      {:credo_envvar, "~> 0.1", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 0.4", only: [:dev, :test], runtime: false},

      # Security check
      {:sobelow, "~> 0.8", only: [:dev, :test], runtime: true},

      # Test factories
      {:ex_machina, "~> 2.3", only: :test},
      {:faker, "~> 0.12", only: :test},

      # Test coverage
      {:excoveralls, "~> 0.11", only: :test}
    ]
  end

  defp releases do
    [
      elixir_boilerplate: [
        version: @version,
        applications: [elixir_boilerplate: :permanent]
      ]
    ]
  end
end
