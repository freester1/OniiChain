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
end