defmodule AgentMissionTest do
  use ExUnit.Case
  doctest AgentMission

  defmodule MainActionHandler do

    def init do
      receive do

      end
    end

    def send_role(pid, role) do
      send pid, {:role, role}
    end

    def send_secret(pid, secret_pid) do
      send pid, {:secret, secret_pid}
    end

    def receive_agents(pid) do
      agents = receive do
        {:agents, agents} -> agents
      after
        100 -> :timeout
      end
      send pid, {:response, agents}
    end
  end

  describe "agent mission" do
    setup do
      pid = spawn(MainActionHandler, :init, [])
      :global.register_name(:main, pid)

      on_exit(fn() ->
        :global.unregister_name(:main)
        Process.exit(pid, :kill)
      end)
  
      {:ok, %{main_pid: pid}}
    end
    
    test "should get role" do
      MainActionHandler.send_role(self, :black)
      assert :black == AgentMission.fetch_role(50)
    end

    test "should get the secret pid" do
      pid = spawn(fn() -> nil end)
      MainActionHandler.send_secret(self, pid)
      assert pid == AgentMission.fetch_secret(50) 
    end

    test "should send agents on mission" do
      pid = spawn(MainActionHandler, :receive_agents, [self])
      :global.unregister_name(:main)
      :global.register_name(:main, pid)

      AgentMission.send_agents([:foo, :bar])

      agents = receive do
        {:response, agents} -> agents
      after 
        100 -> :timeout
      end 
      assert [:foo, :bar] == agents
    end

    test "should send fail mission" do
      task = setup_outcome

      MainActionHandler.send_secret(self, task.pid)
      AgentMission.fail_mission
      
      result = Task.await(task)
      assert :red == result
    end

    test "should send succeed mission" do
      task = setup_outcome
      MainActionHandler.send_secret(self, task.pid)
      AgentMission.success_mission
      
      result = Task.await(task)
      assert :black == result
    end

    defp setup_outcome do
      Task.async(fn -> 
        receive do
          {:outcome, result} -> result
        after
          100 -> :timeout
        end
      end)
    end
  end
end
