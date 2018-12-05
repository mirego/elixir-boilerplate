defmodule PhoenixBoilerplate.Repo do
  use Ecto.Repo,
    adapter: Ecto.Adapters.Postgres,
    otp_app: :phoenix_boilerplate

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, Application.get_env(:phoenix_boilerplate, PhoenixBoilerplate.Repo)[:url])}
  end
end
