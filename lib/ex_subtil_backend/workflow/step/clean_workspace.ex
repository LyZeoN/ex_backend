defmodule ExSubtilBackend.Workflow.Step.CleanWorkspace do

  alias ExSubtilBackend.Jobs
  alias ExSubtilBackend.Amqp.JobFileSystemEmitter
  alias ExSubtilBackend.Workflow.Step.Requirements

  @action_name "clean_workspace"

  def launch(workflow) do

    case get_source_directories(workflow.jobs) do
      [] ->
        Jobs.create_skipped_job(workflow, @action_name)
      paths ->
        requirements = Requirements.add_required_paths(paths)

        job_params = %{
          name: @action_name,
          workflow_id: workflow.id,
          params: %{
            action: "remove",
            requirements: requirements,
            source: %{
              paths: paths
            }
          }
        }

        {:ok, job} = Jobs.create_job(job_params)
        params = %{
          job_id: job.id,
          parameters: job.params
        }
        JobFileSystemEmitter.publish_json(params)
    end
  end

  defp get_source_directories(jobs) do
    dash_directory =
      ExSubtilBackend.Workflow.Step.GenerateDash.get_jobs_destination_paths(jobs)
      |> List.first
      |> Path.dirname

    download_directory =
      ExSubtilBackend.Workflow.Step.FtpDownload.get_jobs_destination_paths(jobs)
      |> List.first
      |> Path.dirname

    [
      dash_directory,
      download_directory
    ]
  end

  @doc """
  Returns the list of destination paths of this workflow step
  """
  def get_jobs_destination_paths(_jobs, result \\ [])
  def get_jobs_destination_paths([], result), do: result
  def get_jobs_destination_paths([job | jobs], result) do
    result =
      case job.name do
        @action_name ->
          job.params
          |> Map.get("destination", %{})
          |> Map.get("paths")
          |> Enum.concat(result)
        _ -> result
      end

    get_jobs_destination_paths(jobs, result)
  end

end