defmodule OniichainWeb.P2pChannel do
  use Phoenix.Channel
  require Logger

  @query_latest_block Oniichain.P2pMessage.query_latest_block
  @query_all_blocks   Oniichain.P2pMessage.query_all_blocks
  @update_block_chain Oniichain.P2pMessage.update_block_chain

  def join(_topic, _payload, socket) do
    {:ok, socket}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end

  def handle_in(@query_latest_block, payload, socket) do
    Logger.info("sending latest block to #{inspect socket}")
    {:reply, {:ok, Oniichain.BlockService.get_latest_block()}, socket}
  end

  def handle_in(@query_all_blocks, payload, socket) do
    Logger.info("sending all blocks to #{inspect socket}")
    {:reply, {:ok, Oniichain.BlockService.get_all_blocks()}, socket}
  end

  def handle_in(event, payload, socket) do
    Logger.warn("unhandled event #{event} #{inspect payload}")
    {:noreply, socket}
  end
end
