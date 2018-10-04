defmodule PhoenixBoilerplate.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_boilerplate,
      version: "0.0.1",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: ["test"],
      test_pattern: "**/*_test.exs",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {PhoenixBoilerplate.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # Phoenix
      {:phoenix, "~> 1.3.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},

      # Database
      {:postgrex, "~> 0.13"},

      # Authentication
      {:basic_auth, "~> 2.2"},

      # HTTP server
      {:cowboy, "~> 1.0"},
      {:plug_canonical_host, "~> 0.3"},

      # Translations
      {:gettext, "~> 0.16"},

      # Errors
      {:sentry, "~> 6.2"},

      # Linting
      {:credo, "~> 0.9", only: [:dev, :test]},

      # OTP Release
      {:distillery, "~> 2.0"},

      # Test coverage
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
