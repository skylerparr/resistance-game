defmodule ClientConnect do
  import PidHelper
  import Logger

  def connect(player_name) when is_atom(player_name) do
    debug "Starting up..."
    if connect_to_main_node do
      join_game(player_name)
    else
      {:error, "connection to main node failed"}
    end
  end

  def connect_to_main_node do
    debug "Connecting to node"
    Node.connect(main_node)
  end

  def join_game(player_name) when is_atom(player_name) do
    attempt_join(player_name, :undefined)
  end

  defp attempt_join(name, :undefined) do
    debug "Finding main name"
    attempt_join name, main_pid
  end

  defp attempt_join(name, main) do
    debug "Sending connect to main"
    send main, {:connect, name, self}
    :ok
  end
  
  defp main_node do
    :"main@#{Application.get_env(:resistance, :main_server_ip)}"
  end

end
