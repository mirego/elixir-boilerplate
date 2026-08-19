defmodule ElixirBoilerplateWeb.Controllers.PageController do
  use ElixirBoilerplateWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
