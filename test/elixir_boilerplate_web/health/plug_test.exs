defmodule ElixirBoilerplateWeb.Health.PlugTest do
  use ElixirBoilerplateWeb.ConnCase

  test "GET /health", %{conn: conn} do
    conn = get(conn, "/health")

    # credo:disable-for-next-line CredoEnvvar.Check.Warning.EnvironmentVariablesAtCompileTime
    version = Application.get_env(:elixir_boilerplate, :version)

    assert json_response(conn, 200) == %{
             "status" => "ok",
             "version" => version
           }
  end
end
