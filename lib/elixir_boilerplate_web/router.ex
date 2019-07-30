defmodule ElixirBoilerplateWeb.Router do
  use Phoenix.Router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:put_content_security_policy)
    plug(:put_layout, {ElixirBoilerplateWeb.Layouts.View, :app})
  end

  scope "/", ElixirBoilerplateWeb do
    pipe_through(:browser)

    get("/", Home.Controller, :index, as: :home)
  end

  def put_content_security_policy(conn, _) do
    content_security_policy =
      Mix.env()
      |> content_security_policy()
      |> Enum.join("; ")

    put_resp_header(conn, "content-security-policy", content_security_policy)
  end

  defp content_security_policy(:dev) do
    ["default-src 'self'", "script-src 'self' 'unsafe-eval' 'unsafe-inline'", "style-src 'self' 'unsafe-inline'"]
  end

  defp content_security_policy(_) do
    ["default-src 'self'"]
  end
end
