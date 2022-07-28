defmodule ElixirBoilerplate.GettextInterpolation do
  @moduledoc """
  Default Gettext.Interpolation implementation for testing purposes

  Appends formatted `bindings` at the end of the string
  """

  @behaviour Gettext.Interpolation

  @doc """
  iex> runtime_interpolate("test", %{})
  {:ok, "test"}
  iex> runtime_interpolate("test", %{arg: 1})
  {:ok, "test[arg=1]"}
  iex> runtime_interpolate("test", %{arg: :atom})
  {:ok, "test[arg=:atom]"}
  iex> runtime_interpolate("test", %{arg: [:atom,:atom2]})
  {:ok, "test[arg=:atom,:atom2]"}
  """
  @impl true
  def runtime_interpolate(message, bindings), do: {:ok, format(message, bindings)}

  @impl true
  defmacro compile_interpolate(_message_type, message, bindings) do
    quote do
      runtime_interpolate(unquote(message), unquote(bindings))
    end
  end

  @impl true
  def message_format, do: "test-format"

  defp format(message, bindings), do: "#{message}#{format_bindings(bindings)}"

  defp format_bindings(bindings) when is_map(bindings) and map_size(bindings) === 0, do: ""

  defp format_bindings(bindings) when is_map(bindings) do
    bindings = Enum.map_join(bindings, ",", fn {key, value} -> "#{key}=#{format_value(value)}" end)
    "[#{bindings}]"
  end

  defp format_bindings(_bindings), do: ""

  defp format_value(value) when is_list(value), do: Enum.map_join(value, ",", &format_value/1)
  defp format_value(value) when is_binary(value), do: value
  defp format_value(value), do: inspect(value)
end
