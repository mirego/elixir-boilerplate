defmodule ElixirBoilerplateWeb.PageHTML do
  use ElixirBoilerplateWeb, :html

  attr :message, :string, default: nil

  def home(assigns) do
    ~H"""
    <div class="home">
      <a target="_blank" href="https://github.com/mirego/elixir-boilerplate">
        <.logo width={500} />
      </a>

      <p>
        This repository is the stable base upon which we build our Elixir projects at Mirego.<br /> We want to share it with the world so you can build awesome Elixir applications too.
      </p>

      <%= if @message do %>
        <p><strong>Message:</strong> <%= @message %></p>
      <% end %>
    </div>
    """
  end
end
