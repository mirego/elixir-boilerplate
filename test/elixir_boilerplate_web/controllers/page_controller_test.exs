defmodule ElixirBoilerplateWeb.Controllers.PageControllerTest do
  use ElixirBoilerplateWeb.ConnCase

  import HTMLTestHelpers

  describe "GET /" do
    test "returns 200", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html_response(conn, 200)
    end

    test "renders title and description", %{conn: conn} do
      conn = get(conn, ~p"/")
      html = html_response(conn, 200)

      html
      |> assert_html_text("home-title", "The stable base for Elixir projects at Mirego.")
      |> assert_html_text(
        "home-description",
        "This boilerplate is the foundation upon which we build our Elixir applications. It comes with batteries included — Phoenix, GraphQL, database, testing, observability and more."
      )
    end

    test "renders stack cards", %{conn: conn} do
      conn = get(conn, ~p"/")
      html = html_response(conn, 200)

      html
      |> assert_html_element_exists("stack-web")
      |> assert_html_element_exists("stack-language")
      |> assert_html_element_exists("stack-graphql")
      |> assert_html_element_exists("stack-database")
      |> assert_html_element_exists("stack-observability")
      |> assert_html_element_exists("stack-version")
    end

    test "renders stack card values", %{conn: conn} do
      conn = get(conn, ~p"/")
      html = html_response(conn, 200)

      html
      |> assert_html_text("stack-graphql", "Absinthe")
      |> assert_html_text("stack-database", "Ecto + PostgreSQL")
      |> assert_html_text("stack-observability", "TelemetryUI")
    end

    test "renders links", %{conn: conn} do
      conn = get(conn, ~p"/")
      html = html_response(conn, 200)

      html
      |> assert_html_attribute("link-github", "href", "https://github.com/mirego/elixir-boilerplate")
      |> assert_html_attribute("link-why", "href", "https://www.mirego.com/en/news/accelerate-the-start-of-new-projects-with-strong-boilerplates")
      |> assert_html_attribute("link-metrics", "href", "/metrics")
    end
  end
end
