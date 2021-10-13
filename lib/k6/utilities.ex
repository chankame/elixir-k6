defmodule K6.Utilities do
  @moduledoc """
  Utility functions for a k6 template
  """

  import Mix.Generator
  alias K6.Template

  @spec generate(binary()) :: :ok
  def generate(path) do
    unless File.exists?(path) do
      create_directory(path)
      create_phoenix_channel(path)
    end

    :ok
  end

  defp create_phoenix_channel(path) do
    target_path = Path.join([path, "phoenix-channel.js"])
    original_path = Template.template_path("utilities/phoenix-channel.js")

    copy_file(original_path, target_path)
  end
end
