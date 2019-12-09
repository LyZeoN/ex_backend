defmodule ExBackend.Docker.Container do
  @moduledoc false

  alias RemoteDockers.ContainerConfig

  def build_config(params) do
    image_name = Map.get(params, "image", nil)
    container_config = ContainerConfig.new(image_name)

    container_config =
      Map.get(params, "volumes", [])
      |> add_volumes(container_config)

    container_config =
      Map.get(params, "environment", %{})
      |> Map.to_list()
      |> add_env_var(container_config)
      |> ContainerConfig.add_extra_host(
        "exchange-manager-api.idfrancetv.perfect-memory.com",
        "192.168.101.103"
      )

    container_config
  end

  defp add_volumes([], config), do: config

  defp add_volumes([volume | volumes], config) do
    config =
      config
      |> ContainerConfig.add_mount_point(volume["host"], volume["container"])

    add_volumes(volumes, config)
  end

  defp add_env_var([], config), do: config

  defp add_env_var([{key, value} | vars], config) do
    config = ContainerConfig.add_env(config, key, value)
    add_env_var(vars, config)
  end
end
