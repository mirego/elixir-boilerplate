defmodule PhoenixBoilerplate.Gettext do
  @moduledoc """
  This module manages everything related to the translations used in the
  application.
  """

  use Gettext, otp_app: :phoenix_boilerplate

  def get_locale do
    __MODULE__
    |> Gettext.get_locale()
    |> String.to_atom()
  end
end
