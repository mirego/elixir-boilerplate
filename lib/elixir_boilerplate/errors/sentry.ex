defmodule ElixirBoilerplate.Errors.Sentry do
  @moduledoc false
  @scrubbed_keys ["first_name", "last_name", "email"]
  @scrubbed_value "*********"

  def scrub_params(conn) do
    conn
    |> Sentry.PlugContext.default_body_scrubber()
    |> scrub_map(@scrubbed_keys)
  end

  def scrubbed_remote_address(_conn), do: @scrubbed_value

  # Reference: https://github.com/getsentry/sentry-elixir/blob/9.1.0/lib/sentry/plug_context.ex#L232
  defp scrub_map(map, scrubbed_keys) do
    Map.new(map, fn {key, value} ->
      value =
        cond do
          key in scrubbed_keys -> @scrubbed_value
          is_struct(value) -> value |> Map.from_struct() |> scrub_map(scrubbed_keys)
          is_map(value) -> scrub_map(value, scrubbed_keys)
          is_list(value) -> scrub_list(value, scrubbed_keys)
          true -> value
        end

      {key, value}
    end)
  end

  # Reference: https://github.com/getsentry/sentry-elixir/blob/9.1.0/lib/sentry/plug_context.ex#L248
  defp scrub_list(list, scrubbed_keys) do
    Enum.map(list, fn value ->
      cond do
        is_struct(value) -> value |> Map.from_struct() |> scrub_map(scrubbed_keys)
        is_map(value) -> scrub_map(value, scrubbed_keys)
        is_list(value) -> scrub_list(value, scrubbed_keys)
        true -> value
      end
    end)
  end
end
