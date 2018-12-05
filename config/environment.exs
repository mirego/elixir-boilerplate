defmodule Environment do
  def get(key), do: System.get_env(key)

  def get_boolean(key) do
    key
    |> get()
    |> parse_boolean()
  end

  def get_integer(key, default \\ 0) do
    key
    |> get()
    |> parse_integer(default)
  end

  def exists?(key) do
    key
    |> get()
    |> case do
      "" -> false
      nil -> false
      _ -> true
    end
  end

  defp parse_boolean("true"), do: true
  defp parse_boolean("1"), do: true
  defp parse_boolean(_), do: false

  defp parse_integer(value, _) when is_bitstring(value), do: String.to_integer(value)
  defp parse_integer(_, default), do: default
end
