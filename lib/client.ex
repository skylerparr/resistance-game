defmodule Client do

  def connect(name) when is_atom(name) do
    IO.puts "Starting up..."
    do_connect(name, false, :undefined)
  end

  def send_agents(agents), do: send main_pid, {:agents, agents}
  def fail_mission, do: send await_secret, {:outcome, :red}
  def success_mission, do: send await_secret, {:outcome, :black}

  def await_secret do
    receive do
      {:secret, pid} -> pid
    end
  end

  def main_pid, do: :global.whereis_name(:main)

  defp do_connect(name, false, :undefined) do
    IO.puts "Connecting to node"
    do_connect name, Node.connect(:"main@10.3.17.68"), :undefined
  end

  defp do_connect(name, true, :undefined) do
    IO.puts "Finding main name"
    do_connect name, true, main_pid
  end

  defp do_connect(name, true, main) do
    IO.puts "Sending connect to main"
    send main, {:connect, name, self}
    wait_for_role
  end

  defp wait_for_role do
    IO.puts "Waiting for role"
    receive do
      {:role, role} -> role
    end
  end

end
