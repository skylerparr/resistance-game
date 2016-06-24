defmodule ClientConnectTest do
  use ExUnit.Case
  doctest ClientConnect
  import Mock

  describe "client connect" do
    setup do
      :ok
    end
    
    test "should connect connect to the main node" do
      with_mock Node, [connect: fn(_) ->
        true
      end] do
        ClientConnect.connect_to_main_node

        assert called Node.connect(:"main@10.3.17.89")
      end
    end
  end
end
