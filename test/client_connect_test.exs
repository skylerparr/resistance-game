defmodule ClientConnectTest do
  use ExUnit.Case
  doctest ClientConnect
  import Mock

  describe "client connect" do
    setup do
      :ok
    end
    
    test "should connect to the main node" do
      with_mock Node, [connect: fn(_) ->
        true
      end] do
        assert ClientConnect.connect_to_main_node
        assert called Node.connect(:"main@10.3.17.89")
      end
    end

    test "should return false if unable to connect" do
      with_mock Node, [connect: fn(_) ->
        false
      end] do
        assert !ClientConnect.connect_to_main_node
      end
    end

    test "should join game" do
      task = Task.async(fn -> 
        receive do
          {:connect, name, pid} -> {name, pid}
        after
          100 -> :timeout
        end
      end)
      :global.register_name(:main, task.pid)

      ClientConnect.join_game(:foo)

      assert {:foo, self} == Task.await(task)
    end
  end
end
