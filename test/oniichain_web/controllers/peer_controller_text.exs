defmodule OniichainWeb.BlockControllerTest do
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
      entry     = :ets.tab2list(:peers) |> hd
      peer_info = entry |> elem(1)
      assert entry |> elem(0)
      assert peer_info["host"] == host && peer_info["port"] == port
    end
  end
end