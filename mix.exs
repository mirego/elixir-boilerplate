defmodule PhoenixBoilerplate.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_boilerplate,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
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
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      # Phoenix
      {:phoenix, "~> 1.3.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},

      # Database
      {:postgrex, ">= 0.0.0"},

      # Authentication
      {:basic_auth, "~> 2.2"},

      # HTTP server
      {:cowboy, "~> 1.0"},

      # Errors
      {:sentry, "~> 5.0"},

      # Linting
      {:credo, "~> 0.8", only: :dev}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
