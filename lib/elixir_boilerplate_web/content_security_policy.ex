defmodule ElixirBoilerplateWeb.ContentSecurityPolicy do
  @doc """
  This plug adds a “Content-Security-Policy” header to responses. You will
  need to customize each directive to fit your application needs.
  """

  use Plug.Builder

  import Phoenix.Controller, only: [put_secure_browser_headers: 2]

  def call(conn, _) do
    directives = [
      "default-src #{default_src_directive()}",
      "form-action #{form_action_directive()}",
      "media-src #{media_src_directive()}",
      "img-src #{image_src_directive()}",
      "script-src #{script_src_directive()}",
      "font-src #{font_src_directive()}",
      "connect-src #{connect_src_directive()}",
      "style-src #{style_src_directive()}",
      "frame-src #{frame_src_directive()}"
    ]

    put_secure_browser_headers(conn, %{"content-security-policy" => Enum.join(directives, "; ")})
  end

  defp default_src_directive, do: "'none'"
  defp form_action_directive, do: "'self'"
  defp media_src_directive, do: "'self'"
  defp font_src_directive, do: "'self'"
  defp connect_src_directive, do: "'self'"
  defp style_src_directive, do: "'self' 'unsafe-inline'"
  defp frame_src_directive, do: "'self'"
  defp image_src_directive, do: "'self' data:"

  defp script_src_directive do
    if Application.get_env(:elixir_boilerplate, __MODULE__)[:allow_unsafe_scripts] do
      "'self' 'unsafe-eval' 'unsafe-inline'"
    else
      "'self'"
    end
  end
end
