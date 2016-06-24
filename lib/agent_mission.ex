defmodule AgentMission do
  import PidHelper
  import Logger

  def send_agents(agents), do: send main_pid, {:agents, agents}
  def fail_mission, do: send fetch_secret, {:outcome, :red}
  def success_mission, do: send fetch_secret, {:outcome, :black}

  def fetch_secret(timeout \\ 5_000) do
    receive do
      {:secret, pid} -> pid
    after
      timeout -> :timeout
    end
  end

  def fetch_role(timeout \\ 60_000) do
    debug "Waiting for role"
    receive do
      {:role, role} -> role
    after
      timeout -> :timeout
    end
  end

end
