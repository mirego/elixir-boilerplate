defmodule ElixirBoilerplate.ConfigHelpers do
  @moduledoc """
  This modules provides various helpers to handle environment metadata
  """

  @type value_type :: :string | :integer | :boolean | :uri | :cors
  @type config_type :: String.t() | integer() | boolean() | URI.t() | [String.t()]

  @spec get_env(String.t(), nil | value_type()) :: config_type()
  def get_env(key, type \\ :string) do
    System.get_env(key)
    |> parse_env(type)
  end

  @spec get_env!(String.t(), nil | value_type()) :: config_type()
  def get_env!(key, type \\ :string) do
    System.fetch_env!(key)
    |> parse_env(type)
  end

  defp parse_env(value, :string), do: value
  defp parse_env(value, :integer), do: String.to_integer(value)

  defp parse_env(nil, :boolean), do: false
  defp parse_env("", :boolean), do: false
  defp parse_env(value, :boolean), do: String.downcase(value) in ~w(true 1)

  defp parse_env(nil, :cors), do: nil

  defp parse_env(value, :cors) when is_bitstring(value) do
    value
    |> String.split(",")
    |> case do
      [origin] -> origin
      origins -> origins
    end
  end

  defp parse_env(nil, :uri), do: nil
  defp parse_env("", :uri), do: nil
  defp parse_env(value, :uri), do: URI.parse(value)

  @spec get_endpoint_url_config(URI.t() | any()) :: nil | [scheme: String.t(), host: String.t(), port: String.t()]
  def get_endpoint_url_config(%URI{scheme: scheme, host: host, port: port}), do: [scheme: scheme, host: host, port: port]
  def get_endpoint_url_config(_invalid), do: nil

  @spec get_uri_part(URI.t() | any(), :scheme | :host | :port) :: String.t() | nil
  def get_uri_part(%URI{scheme: scheme}, :scheme), do: scheme
  def get_uri_part(%URI{host: host}, :host), do: host
  def get_uri_part(%URI{port: port}, :port), do: port
  def get_uri_part(_invalid, _part), do: nil
end
