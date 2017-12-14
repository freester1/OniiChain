defmodule Oniichan.P2pSessionManagerTest do
  use ExUnit.Case, async: false
  import Oniichain.TestUtil, only: [reset_db: 0]
  import Oniichain.P2pSessionManager, only: [connect: 2, terminate_session: 1]
  setup() do
    reset_db()
    :ok
  end

  describe("connect") do
    test "adds a user to the peers table with a pid" do
      prev_entries = :ets.tab2list(:peers)
      connect("localhost", 44444)
      assert :ets.tab2list(:peers) |> length > prev_entries |> length
    end

    test "does not add the same server twice" do
      assert connect("localhost", 44444) == :ok
      assert connect("localhost", 44444) == :fail
    end
  end

  describe("terminate_session") do
    test "removes the given pid from the ets table" do
      {:ok, pid} = Oniichain.P2pClientHandler.start_link("localhost", 9999)
      :ets.insert(:peers, {pid, %{}})
      terminate_session(pid)
      assert :ets.tab2list(:peers) |> length == 0
    end
  end
end
