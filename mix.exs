defmodule ElixirBoilerplate.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_boilerplate,
      version: "0.0.1",
      erlang: "~> 27.0",
      elixir: "~> 1.20",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: ["test"],
      test_pattern: "**/*_test.exs",
      test_coverage: [tool: ExCoveralls],
      start_permanent: Mix.env() == :prod,
      listeners: [Phoenix.CodeReloader],
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer(),
      releases: releases(),
      compilers: [:phoenix_live_view] ++ Mix.compilers()
    ]
  end

  def cli do
    [
      preferred_envs: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      mod: {ElixirBoilerplate.Application, []},
      extra_applications: extra_applications(Mix.env()) ++ [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp extra_applications(:dev), do: [:observer, :wx]
  defp extra_applications(_), do: []

  defp aliases do
    [
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["compile", "tailwind elixir_boilerplate", "esbuild elixir_boilerplate"],
      "assets.deploy": [
        "tailwind elixir_boilerplate --minify",
        "esbuild elixir_boilerplate --minify",
        "phx.digest"
      ],
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp deps do
    [
      # Assets bundling
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},

      # Tailwind CSS
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:heroicons, github: "tailwindlabs/heroicons", tag: "v2.2.0", sparse: "optimized", app: false, compile: false, depth: 1},

      # HTTP Client
      {:finch, "~> 0.21"},
      {:req, "~> 0.5"},

      # HTTP server
      {:bandit, "~> 1.5"},
      {:plug_canonical_host, "~> 2.0"},
      {:corsica, "~> 2.1"},

      # Phoenix
      {:phoenix, "~> 1.8"},
      {:phoenix_html, "~> 4.3"},
      {:phoenix_live_view, "~> 1.1"},
      {:phoenix_ecto, "~> 4.7"},
      {:phoenix_live_reload, "~> 1.6", only: :dev},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:jason, "~> 1.4"},

      # GraphQL
      {:absinthe, "~> 1.10"},
      {:absinthe_security, "~> 0.1"},
      {:absinthe_plug, "~> 1.5"},
      {:dataloader, "~> 2.0"},
      {:absinthe_error_payload, "~> 1.1"},

      # Database
      {:ecto_sql, "~> 3.13"},
      {:postgrex, "~> 0.22"},
      {:ecto_psql_extras, "~> 0.8"},

      # Database check
      {:excellent_migrations, "~> 0.1", only: [:dev, :test], runtime: false},

      # Translations
      {:gettext, "~> 1.0", override: true},

      # Errors
      {:sentry, "~> 12.0"},

      # Telemetry
      {:telemetry_ui, "~> 5.4"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},

      # Linting
      {:credo, "~> 1.7", only: [:dev, :test], override: true},
      {:credo_envvar, "~> 0.1", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 2.0", only: [:dev, :test], runtime: false},
      {:styler, "~> 1.11", only: [:dev, :test], runtime: false},

      # Security check
      {:sobelow, "~> 0.14", only: [:dev, :test], runtime: true},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},

      # Health
      {:plug_checkup, "~> 0.6"},

      # Test factories
      {:ex_machina, "~> 2.8", only: :test},
      {:faker, "~> 0.19", only: :test},

      # Test HTML helpers
      {:html_test_helpers, "~> 0.1", only: :test},
      {:html_test_identifiers, "~> 0.2"},

      # Test coverage
      {:excoveralls, "~> 0.18", only: :test},

      # Dialyzer
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
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
