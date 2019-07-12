defmodule ElixirBoilerplateWeb.Router do
  use Phoenix.Router

  @secure_headers %{"content-security-policy" => "default-src 'self'"}

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers, @secure_headers)
    plug(:put_layout, {ElixirBoilerplateWeb.Layouts.View, :app})
  end

  scope "/", ElixirBoilerplateWeb do
    pipe_through(:browser)

    get("/", Home.Controller, :index, as: :home)
  end
end
