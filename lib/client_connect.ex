defmodule ClientConnect do
  import PidHelper
  import Logger

  def connect(name) when is_atom(name) do
    debug "Starting up..."
    #connect_to_main_node

  end

  def connect_to_main_node do
    debug "Connecting to node"
    if !Node.connect(main_node) do
      connect_to_main_node
    end
  end

  def connect_to_main_node(name, false) do
    #connect_to_main_node name
  end

  def connect_to_main_node(name, true) do
    :ok
  end

  defp do_connect(name, true, :undefined) do
    debug "Finding main name"
    do_connect name, true, main_pid
  end

  defp do_connect(name, true, main) do
    debug "Sending connect to main"
    send main, {:connect, name, self}
    :ok
  end
  
  defp main_node do
    :"main@#{Application.get_env(:resistance, :main_server_ip)}"
  end

end
