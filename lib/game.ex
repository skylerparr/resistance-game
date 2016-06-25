defmodule Game do
  
  @roles [:black, :black, :black, :red]

  def init do
    :global.register_name(:main, self)

    wait_connect(%{})
      |> register_player_pids
      |> assign_roles
      |> distribute_roles
      |> GameLoop.play_game
  end

  defp wait_connect(players) when map_size(players) == 4, do: players
  defp wait_connect(players) do
    {name, pid} = receive do
      {:connect, name, pid} -> {name, pid}
    end
    IO.inspect "#{name} connected"

    players = Map.put(players, name, pid)

    IO.inspect map_size(players)

    wait_connect(players)
  end

  defp register_player_pids(players) do
    Enum.each(players, fn({name, pid}) ->
      :global.register_name(name, pid)
    end)

    players
  end

  defp assign_roles(players) do
    roles = Enum.shuffle(@roles)

    player_roles = players
      |> Enum.zip(roles)
      |> Enum.map(fn({{name, pid}, role}) ->
        %Player{name: name, pid: pid, role: role}
      end)
  end
  
  defp distribute_roles(player_roles) do
    Enum.each(player_roles, fn(player) -> 
      send player.pid, {:role, player.role}
    end)

    player_roles
  end

end
