defmodule ElixirBoilerplate.Gettext do
  @moduledoc """
  This module manages everything related to the translations used in the
  application.
  """

  use Gettext.Backend, otp_app: :elixir_boilerplate
end
