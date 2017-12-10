defmodule OniichainWeb.PeerController do
  use OniichainWeb, :controller
  @moduledoc """
    Functionality for managing peers
  """

  def add_peer(conn, peer_data) do
    host = peer_data["host"]
    port = peer_data["port"]
    :ets.insert(:peers, {Ksuid.generate(), %{host: host, port: port}})
    #TODO: connect to peer

    render(conn, "200.json", %{})
  end

  def get_all_peers(conn, _) do
    peers = :ets.tab2list(:peers)
      |> Enum.map(fn (peer_entry) ->
        peer_entry |> elem(1)
      end)
      render(conn, "peers.json", %{peers: peers})
  end
end