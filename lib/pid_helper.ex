defmodule PidHelper do
  def main_pid, do: :global.whereis_name(:main)
end
