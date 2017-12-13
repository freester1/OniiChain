defmodule OniichainWeb.P2pChannel do
  use Phoenix.Channel
  require Logger

  @query_latest_block Oniichain.P2pMessage.query_latest_block
  @query_all_blocks   Oniichain.P2pMessage.query_all_blocks
  @update_block_chain Oniichain.P2pMessage.update_block_chain
  @add_peer_request   Oniichain.P2pMessage.add_peer_request
  @connection_error   Oniichain.P2pMessage.connection_error
  @connection_success Oniichain.P2pMessage.connection_success

  def join(_topic, _payload, socket) do
    {:ok, socket}
  end

  def handle_info(_message, socket) do
    require IEx; IEx.pry
    {:noreply, socket}
  end

  def handle_in(@query_latest_block, payload, socket) do
    Logger.info("sending latest block to #{inspect socket}")
    {:reply, {:ok, %{type: @query_latest_block, data: Oniichain.BlockService.get_latest_block()}}, socket}
  end

  def handle_in(@query_all_blocks, payload, socket) do
    Logger.info("sending all blocks to #{inspect socket}")
    {:reply, {:ok, %{type: @query_all_blocks, data: Oniichain.BlockChainRepository.get_all_blocks()}}, socket}
  end

  def handle_in(@add_peer_request, payload, socket) do
    Logger.info("attempting to connect to #{inspect payload}...")
    result = Oniichain.P2pSessionManager.connect(payload["host"], payload["port"])
    if result == :fail do
      {:reply, {:ok, %{type: @connection_error}}, socket}
    else
      {:reply, {:ok, %{type: @connection_success}}, socket}
    end
  end

  def handle_in(event, payload, socket) do
    require IEx; IEx.pry
    Logger.warn("unhandled event #{event} #{inspect payload}")
    {:noreply, socket}
  end
end
