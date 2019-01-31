defmodule ElixirBoilerplateWeb.Router do
  use Phoenix.Router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ElixirBoilerplateWeb do
    pipe_through(:api)

    get("/health", Health.Controller, :index)
  end
end
