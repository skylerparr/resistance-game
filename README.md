# Resistance Card Game

Using distributed elixir to play the resistance card game.

## How to run the server
  
    $ mix deps.get
    $ iex --name main@#{server ip address} --cookie #{share a common cookie} -S mix 
    iex> Game.init

## How to run the client

    $ iex --name #{your name}@#{your ip address} --cookie #{same cookie as server} -S mix

