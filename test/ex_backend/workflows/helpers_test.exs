defmodule ExBackend.HelpersTest do
  use ExBackendWeb.ConnCase

  require Logger

  def port_format(port) when is_integer(port) do
    Integer.to_string(port)
  end

  def port_format(port) do
    port
  end

  defp clean_queue(channel, queue) do
    case AMQP.Basic.get channel, queue do
      {:ok, _, %{delivery_tag: delivery_tag}} ->
        AMQP.Basic.ack(channel, delivery_tag)
        clean_queue(channel, queue)
      _ -> :ok
    end
  end

  def get_amqp_connection() do
    hostname = System.get_env("AMQP_HOSTNAME") || Application.get_env(:amqp, :hostname)
    username = System.get_env("AMQP_USERNAME") || Application.get_env(:amqp, :username)
    password = System.get_env("AMQP_PASSWORD") || Application.get_env(:amqp, :password)

    virtual_host =
      System.get_env("AMQP_VHOST") || Application.get_env(:amqp, :virtual_host) || ""

    virtual_host =
      case virtual_host do
        "" -> virtual_host
        _ -> "/" <> virtual_host
      end

    port =
      System.get_env("AMQP_PORT") || Application.get_env(:amqp, :port) ||
        5672
        |> port_format

    url = "amqp://" <> username <> ":" <> password <> "@" <> hostname <> ":" <> port <> virtual_host

    {:ok, connection} = AMQP.Connection.open(url)
    {:ok, channel} = AMQP.Channel.open(connection)

    clean_queue(channel, "job_ftp")
    clean_queue(channel, "job_http")
    clean_queue(channel, "job_gpac")
    clean_queue(channel, "job_ffmpeg")
    clean_queue(channel, "job_rdf")
    clean_queue(channel, "job_file_system")
    clean_queue(channel, "job_speech_to_text")

    channel
  end

  def validate_message_format(%{"job_id" => job_id, "parameters" => parameters})
    when is_integer(job_id) and is_list(parameters) do
    Enum.map(parameters, fn parameter -> validate_parameter(parameter) end)
    |> Enum.filter(fn x -> x == false end)
    |> length == 0
  end
  def validate_message_format(_), do: false

  defp validate_parameter(%{"id" => id, "type" => "string", "value" => value})
    when is_bitstring(id) and is_bitstring(value) do
    true
  end
  defp validate_parameter(%{"id" => id, "type" => "credential", "value" => value})
    when is_bitstring(id) and is_bitstring(value) do
    true
  end
  defp validate_parameter(%{"id" => id, "type" => type, "value" => value})
    when is_bitstring(id) and is_bitstring(type) and is_map(value) do
    true
  end
  defp validate_parameter(%{"id" => id, "type" => type, "value" => value})
    when is_bitstring(id) and is_bitstring(type) and is_list(value) do
    true
  end
  defp validate_parameter(%{"id" => id, "type" => "boolean", "value" => value})
    when is_bitstring(id) and is_boolean(value) do
    true
  end
  defp validate_parameter(%{"id" => id, "type" => "integer", "value" => value})
    when is_bitstring(id) and is_integer(value) do
    true
  end
  defp validate_parameter(param) do
    IO.inspect(param)
    false
  end

  def check(workflow_id, total) do
    all_jobs =
      ExBackend.Jobs.list_jobs(%{
        "workflow_id" => workflow_id |> Integer.to_string(),
        "size" => 50
      })
      |> Map.get(:data)

    assert length(all_jobs) == total
  end

  def check(workflow_id, type, total) do
    all_jobs =
      ExBackend.Jobs.list_jobs(%{
        "job_type" => type,
        "workflow_id" => workflow_id |> Integer.to_string(),
        "size" => 50
      })
      |> Map.get(:data)

    assert length(all_jobs) == total
  end

  def complete_jobs(workflow_id, type) do
    all_jobs =
      ExBackend.Jobs.list_jobs(%{
        "job_type" => type,
        "workflow_id" => workflow_id |> Integer.to_string(),
        "size" => 50
      })
      |> Map.get(:data)

    for job <- all_jobs do
      ExBackend.Jobs.Status.set_job_status(job.id, "completed")
    end

    all_jobs
  end

  def set_output_files(workflow_id, type, paths) do
    all_jobs =
      ExBackend.Jobs.list_jobs(%{
        "job_type" => type,
        "workflow_id" => workflow_id |> Integer.to_string(),
        "size" => 50
      })
      |> Map.get(:data)

    for job <- all_jobs do
      params =
        job.params
        |> Map.put(:destination, %{paths: paths})

      ExBackend.Jobs.update_job(job, %{params: params})
    end
  end
end
