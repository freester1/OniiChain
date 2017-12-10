defmodule OniichainWeb.BlockControllerTest do
  use OniichainWeb.ConnCase
  use Phoenix.ConnTest
  use ExUnit.Case, async: false
  import Oniichain.TestUtil, only: [reset_db: 0]
  import Oniichain.BlockService, only: [get_latest_block: 0]
  setup do
    reset_db()
    {:ok, conn: put_req_header(build_conn(), "accept", "application/json")}
  end

  describe "add_block" do
    test "adds a block to the block chain with the given data", %{conn: _} do
      old_block = get_latest_block()
      data      = "wow data"
      post(build_conn(), "/api/block", [data: data])
      assert get_latest_block() != old_block
      assert get_latest_block().data == data
    end
  end
end