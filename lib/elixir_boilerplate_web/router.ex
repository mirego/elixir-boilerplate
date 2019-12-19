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
    plug(ElixirBoilerplateWeb.ContentSecurityPolicy)
    plug(:put_layout, {ElixirBoilerplateWeb.Layouts.View, :app})
  end

  forward(
    "/health",
    PlugCheckup,
    PlugCheckup.Options.new(
      json_encoder: Jason,
      checks: ElixirBoilerplateHealth.checks(),
      error_code: ElixirBoilerplateHealth.error_code(),
      timeout: :timer.seconds(5),
      pretty: false
    )
  )

  scope "/", ElixirBoilerplateWeb do
    pipe_through(:browser)

    get("/", Home.Controller, :index, as: :home)
  end
end
