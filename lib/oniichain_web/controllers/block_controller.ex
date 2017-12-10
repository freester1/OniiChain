defmodule OniichainWeb.BlockController do
  use OniichainWeb, :controller

  def add_block(conn, payload) do
    block = Oniichain.BlockService.create_next_block(payload["data"])
    Oniichain.BlockService.add_block(block)
    render(conn, "200.json", %{})
  end

  def get_all_blocks(conn, _) do
    all_blocks = :ets.tab2list(:block_chain) 
      |> Enum.filter(fn(block_entry) -> 
        elem(block_entry, 0) != :latest
      end)
      |> Enum.map(fn (block_entry) -> block_entry |> elem(1) end)
    render(conn, "blocks.json", %{blocks: all_blocks})
  end 
end
