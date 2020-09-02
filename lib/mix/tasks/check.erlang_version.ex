defmodule Mix.Tasks.Check.ErlangVersion do
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
    actual_version = sanitize_version(Hex.Utils.otp_version())

    if !Version.match?(actual_version, expected_version) do
      Mix.raise("You're trying to run #{app} on Erlang/OTP #{actual_version} but it has declared in its mix.exs file it supports only Erlang/OTP #{expected_version}")
    end
  end

  # OTP versions are not always compatible with Semantic Versioning. For
  # example, `21.3` and `21.3.0.1` are valid OTP versions, but not valid
  # “semver” ones. We need to set them both to `21.3.0` to match it against our
  # expected version requirement.
  defp sanitize_version(version) do
    version
    |> String.trim()
    |> String.split(".")
    |> case do
      [major] -> "#{major}.0.0"
      [major, minor] -> "#{major}.#{minor}.0"
      [major, minor, patch | _] -> "#{major}.#{minor}.#{patch}"
    end
  end
end
