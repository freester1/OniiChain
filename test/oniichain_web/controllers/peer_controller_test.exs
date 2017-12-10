defmodule OniichainWeb.PeerControllerTest do
  use OniichainWeb.ConnCase
  use Phoenix.ConnTest
  use ExUnit.Case, async: false
  import Oniichain.TestUtil, only: [reset_db: 0]

  setup do
    reset_db()
    {:ok, conn: put_req_header(build_conn(), "accept", "application/json")}
  end

  describe "add_peer" do
    test "adds a peer to the ets table with a uuid and the given host and port", %{conn: _} do
      host = "127.0.0.2"
      port = 9875
      post(build_conn(), "/oniichain/v1/peer", [host: host, port: port])
      {ksuid, peer_info} = :ets.tab2list(:peers) |> hd

      assert ksuid
      assert peer_info[:host] == host && peer_info[:port] == port
    end
  end

  describe "get_all_peers" do
    test "gets all of the current peers" do
      post(build_conn(), "/oniichain/v1/peer", [host: "123.2.2", port: 12345])
      post(build_conn(), "/oniichain/v1/peer", [host: "123.1.1", port: 1234])

      current_peers_length = :ets.tab2list(:peers) |> length
      conn          = get(build_conn(), peer_path(build_conn(), :get_all_peers))
      json_response = json_response(conn, 200)
      assert json_response
      assert json_response["peers"] |> length == current_peers_length
    end
  end
end
