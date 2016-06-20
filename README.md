# Resistance Card Game

Using distributed elixir to play the resistance card game.

## How to run the server
  
    $ mix deps.get
    $ iex -S mix --name main@#{server ip address} --cookie #{share a common cookie}
    iex> Game.init

## How to run the client

    $ iex -S mix --name #{your name}@#{your ip address} --cookie #{same cookie as server}

