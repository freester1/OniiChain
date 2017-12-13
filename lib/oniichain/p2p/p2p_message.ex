defmodule Oniichain.P2pMessage do
  @moduledoc """
  p2p messaging protocol. Defines message options.
  """
  @query_latest_block "get_latest_block"
  @query_all_blocks   "get_all_blocks"
  @update_block_chain "update_block_chain"
  @add_peer_request   "add_peer_request"

  def query_latest_block , do: @query_latest_block
  def query_all_blocks   , do: @query_all_blocks
  def update_block_chain , do: @update_block_chain
  def add_peer_request   , do: @add_peer_request
end
