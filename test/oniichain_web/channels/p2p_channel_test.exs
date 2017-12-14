defmodule OniichainWeb.P2pChannelTest do
  use ExUnit.Case, async: false
  import Oniichain.TestUtil, only: [reset_db: 0]
  import Oniichain.P2pMessage
  setup() do
    reset_db()
    :ok
  end

  test "handling @query_latest_block returns the latest block" do
    {:ok, result} = OniichainWeb.P2pChannel.handle_in(query_latest_block(), %{}, %{}) |> elem(1)
    assert result[:type] == query_latest_block()
    assert result[:data] == Oniichain.BlockChainRepository.get_latest_block()
  end

  test "handling @query_all_blocks returns all the blocks" do
    {:ok, result} = OniichainWeb.P2pChannel.handle_in(query_all_blocks(), %{}, %{}) |> elem(1)
    assert result[:type] == query_all_blocks()
    assert result[:data] == Oniichain.BlockChainRepository.get_all_blocks()
  end

  describe "handling @add_peer_request" do
    test "sends a connection error if the peer is already added" do
      :ets.insert(:peers, {2, %{host: 1, port: 3}})
      {:ok, result} = OniichainWeb.P2pChannel.handle_in(add_peer_request(), %{"host" => 1, "port" => 3}, %{}) |> elem(1)
      assert result[:type] == connection_error()
    end

    test "sends a connection success if the peer connection was successful" do
      {:ok, result} = OniichainWeb.P2pChannel.handle_in(add_peer_request(), %{"host" => "localhost", "port" => 4000}, %{}) |> elem(1)
      assert result[:type] == connection_success()
    end
  end
end
