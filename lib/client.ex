defmodule Client do

  def connect(false, :undefined) do
    IO.puts "Connecting to node"
    connect Node.connect(:"main@10.3.17.68"), :undefined
  end

  def connect(true, :undefined) do
    IO.puts "Finding main name"
    connect true, find_main
  end

  def connect(true, main) do
    IO.puts "Sending connect to main"
    send main, {:connect, :donald, self}
    wait_for_role
  end

  def connect do
    IO.puts "Starting up..."
    connect(false, :undefined)
  end

  def wait_for_role do
    IO.puts "Waiting for role"
    receive do
      {:role, role} -> role
    end
  end

  def send_agents(agents), do: send find_main, {:agents, agents}

  def send_outcome(:red), do: send await_secret, {:outcome, :red}
  def send_outcome(:black), do: send await_secret, {:outcome, :black}

  def await_secret do
    receive do
      {:secret, pid} -> pid
    end
  end

  def find_main do
    :global.whereis_name(:main)
  end
end
