defmodule OniichainWeb.BlockController do
  use OniichainWeb, :controller
  @moduledoc """
    Functionality related to blocks in the block chain
  """

  def add_block(conn, payload) do
    block = Oniichain.BlockService.create_next_block(payload["data"])
    Oniichain.BlockService.add_block(block)
    render(conn, "200.json", %{})
  end

  def get_all_blocks(conn, _) do
    all_blocks = Oniichain.BlockChainRepository.get_all_blocks()
    render(conn, "blocks.json", %{blocks: all_blocks})
  end
end
