defmodule GameLoop do

  def play_game(_, 3, _), do: IO.inspect "winners"
  def play_game(_, _, 3), do: IO.inspect "losers"
  def play_game(players = [next_player | rest], wins \\ 0, losses \\ 0) do
    {wins, losses} = pick_your_agents(next_player, players)
      |> successful_mission?
      |> update_score(wins, losses)

    play_game(rest ++ [next_player], wins, losses)
  end

  def pick_your_agents(player, all_players) do
    IO.inspect "#{player.name} pick your agents:"
    IO.inspect Enum.map(all_players, fn(player) -> player.name end)
    IO.inspect "hint: {:agents, []}"

    receive do
      {:agents, list_of_agents} -> list_of_agents
    end
  end

  defp successful_mission?(agents) do
    Enum.map(agents, fn(agent) ->
      task = Task.async(fn -> 
        IO.inspect "#{agent} pick your {:outcome, :red|:black}"
        receive do
          {:outcome, outcome} -> outcome
        end
      end)
      send :global.whereis_name(agent), {:secret, task.pid}
      task
    end)
    |> Task.yield_many(5 * 30 * 1000)
    |> Enum.all?(fn({_task,{:ok, outcome}}) -> outcome == :black end)
  end

  def update_score(true, wins, losses), do: {wins + 1, losses}
  def update_score(false, wins, losses), do: {wins, losses + 1}
end
