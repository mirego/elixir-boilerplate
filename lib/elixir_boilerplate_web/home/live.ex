defmodule ElixirBoilerplateWeb.Home.Live do
  @moduledoc false
  use Phoenix.LiveView, layout: {ElixirBoilerplateWeb.Layouts, :live}

  on_mount(Sentry.LiveViewHook)

  def mount(_, _, socket) do
    socket = assign(socket, :message, "Hello, world!")
    socket = assign(socket, :counter, 0)
    socket = assign(socket, :page_title, "Home")

    {:ok, socket}
  end

  def render(assigns), do: ElixirBoilerplateWeb.Home.HTML.index_live(assigns)

  def handle_event("increment_counter", _, socket) do
    socket = assign(socket, :counter, socket.assigns.counter + 1)
    {:noreply, socket}
  end

  def handle_event("decrement_counter", _, socket) do
    socket = assign(socket, :counter, socket.assigns.counter - 1)
    {:noreply, socket}
  end

  def handle_event("add_flash_success", _, socket) do
    socket = put_flash(socket, :success, "Success: #{DateTime.utc_now()}")
    {:noreply, socket}
  end

  def handle_event("add_flash_error", _, socket) do
    socket = put_flash(socket, :error, "Error: #{DateTime.utc_now()}")
    {:noreply, socket}
  end
end
