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

    if !Version.match?(actual_version, expected_version) do
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
      {:ok, version} -> sanitize_version(String.trim(version))
      _ -> nil
    end
  end

  defp sanitize_version(version) do
    ~r/^\d+\.\d+$/
    |> Regex.run(version)
    |> case do
      [version] ->
        # OTP versions are not always compatible with Semantic Versioning. For example,
        # `21.3` is a valid OTP version, but is not a valid “semver” one. We need to set
        # it to `21.3.0` to match it against our expected version requirement.
        "#{version}.0"

      nil ->
        version
    end
  end
end
