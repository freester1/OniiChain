defmodule Oniichain.P2pSessionManager do
  @moduledoc """
  Oversees clients for each p2p session, using them to send messages.
  """

  def connect(host, port) do
    {:ok, pid} = Oniichain.P2pClientHandler.start_link(host, port)
    :ets.insert(:peers, {pid, %{host: host, port: port}})
  end

  def broadcast(message) do
    :ets.tab2list(:peers)
    |> Enum.each(fn(peer_entry) ->
      pid = peer_entry |> elem(0)
      Process.send(pid, message, [])
    end)
  end
end
