defmodule OniichainWeb.BlockController do
  use OniichainWeb, :controller

  def add_block(conn, payload) do
    block = OniichainWeb.BlockService.create_next_block(payload["data"])
    OniichainWeb.BlockService.add_block(block)
    render(conn, "200.json", %{})
  end
end
