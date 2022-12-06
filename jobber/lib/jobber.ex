defmodule Jobber do
  alias Jobber.{JobRunner, JobSupervisor}
  @moduledoc """
  Documentation for `Jobber`.
  """

  @doc """
  """
  def start_job(args) do
    if (Enum.count(running_imports()) < 5) do
      DynamicSupervisor.start_child(JobRunner, {JobSupervisor, args})
    else
      {:error, :import_quota_reached}
    end
  end

  def running_imports() do
    match_all = {:"$1", :"$2", :"$3"}
    guards = [{:"==", :"$3", "import"}]
    map_result = [%{id: :"$1", pid: :"$2", type: :"$3"}]

    Registry.select(Jobber.JobRegistry, [{match_all, guards, map_result}])
  end
end
