defmodule Mix.Tasks.Erlang.CheckVersion do
  use Mix.Task

  @shortdoc "Check the Erlang/OTP version"

  @impl true
  def run(args) do
    config = Mix.Project.config()

    check_erlang_version(config, args)
  end

  defp check_erlang_version(config, _) do
    app = ":#{Keyword.get(config, :app)}"
    expected_version = Keyword.get(config, :erlang)
    actual_version = otp_release_version()

    if actual_version != expected_version do
      Mix.raise("You're trying to run #{app} on Erlang/OTP #{actual_version} but it has declared in its mix.exs file it supports only Erlang/OTP #{expected_version}")
    end
  end

  defp otp_release_version do
    [
      :code.root_dir(),
      "releases",
      :erlang.system_info(:otp_release),
      "OTP_VERSION"
    ]
    |> Path.join()
    |> File.read()
    |> case do
      {:ok, version} ->
        String.trim(version)

      _ ->
        nil
    end
  end
end
