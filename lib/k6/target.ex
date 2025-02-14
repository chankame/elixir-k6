defmodule K6.Target do
  @moduledoc """
  Get k6 target version according to system
  """
  @type file_type :: :zip | :tar_gz
  @type target :: String.t()
  @type checksum :: String.t()

  @known_checksums %{
    "k6-v0.34.1-linux-amd64.tar.gz" =>
      "932668f86b4f5cfd4d33cd7c05651f9638570ccf303480ab5c207cba394e1732",
    "k6-v0.34.1-linux-arm64.tar.gz" =>
      "3f18dec2433c65cdc1bc1ddeafeabe77e9be00443987f5ec85e60c1504a13144",
    "k6-v0.34.1-macos-amd64.zip" =>
      "b852687554455dd98b8a3c193608503263e87899be18e337e7473ae656c273f2",
    "k6-v0.34.1-macos-arm64.zip" =>
      "211fdce7f33df0643e0aaca59af9550b8c999cb6d4bbd6b741db059ecf9d7d73",
    "k6-v0.35.0-linux-amd64.tar.gz" =>
      "71d27146ca1da986157844e90e3907f1a79ec4827bd478a89d14c54b8b2fe2ae",
    "k6-v0.35.0-linux-arm64.tar.gz" =>
      "ece33afc2443af4d95429ad86dbb7bc726c3c734ed2a61805feec9a69be17c28",
    "k6-v0.35.0-macos-amd64.zip" =>
      "dce9644a1777cfdded78617893e54a33d5100eb2dec124053a0cee09976da826",
    "k6-v0.35.0-macos-arm64.zip" =>
      "2c46c24bf8c317de3c2fa6cee7de4d3e2634d0e523daa6435956fdbc8ce64753"
  }

  @doc """
  Get k6 target version
  """
  @spec get!(String.t()) :: {file_type(), target(), checksum()}
  def get!(version, platform \\ &platform/0) do
    {archive_type, target} =
      case platform.() do
        {:x86, :darwin} -> {:zip, "k6-#{version}-macos-amd64.zip"}
        {:x86, :linux} -> {:tar_gz, "k6-#{version}-linux-amd64.tar.gz"}
        {:arm, :darwin} -> {:zip, "k6-#{version}-macos-arm64.zip"}
        {:arm, :linux} -> {:tar_gz, "k6-#{version}-linux-arm64.tar.gz"}
        other -> raise "Not implemented for #{inspect(other)}"
      end

    {archive_type, target, checksum_for(target)}
  end

  defp platform do
    case {architecture(), :os.type()} do
      {'x86_64', {:unix, :darwin}} -> {:x86, :darwin}
      {'arm', {:unix, :darwin}} -> {:arm, :darwin}
      {'x86_64', {:unix, :linux}} -> {:x86, :linux}
      {'arm', {:unix, :linux}} -> {:arm, :linux}
    end
  end

  defp architecture do
    arch_str = :erlang.system_info(:system_architecture)
    [arch | _] = :string.split(arch_str, '-')
    arch
  end

  defp checksum_for(target), do: Map.get(@known_checksums, target)
end
