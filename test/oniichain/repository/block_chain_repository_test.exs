defmodule Oniichan.BlockChainRepositoryTest do
  use ExUnit.Case, async: false
  import Oniichain.TestUtil, only: [reset_db: 0]
  import Oniichain.BlockService, only: [create_next_block: 1]
  import Oniichain.BlockChainRepository, only: [insert_block: 1, get_all_blocks: 0]
  setup do
    reset_db()
    :ok
  end

  describe "insert_block" do
    test "inserts block to mnesia with same fields" do
      block = create_next_block("blargh")
      insert_block(block)
      persisted_block = :mnesia.dirty_read({:block_chain, block.index}) |> hd
      assert persisted_block |> elem(1) == block.index
      assert persisted_block |> elem(2) == block.previous_hash
      assert persisted_block |> elem(3) == block.timestamp
      assert persisted_block |> elem(4) == block.data
      assert persisted_block |> elem(5) == block.hash
    end
  end

  describe "get_all_blocks" do
    test "returns a list of all of the blocks in the block chain table" do
      blockA = create_next_block("blargh")
      :ets.insert(:latest_block, {:latest, blockA})
      blockB = create_next_block("foo")
      insert_block(blockA)
      insert_block(blockB)
      list_of_blocks = get_all_blocks()
      assert list_of_blocks |> length == 3
      list_of_blocks
      |> Enum.each(fn (block) ->
        # ignore genesis block
        if block.index > 0 do
          assert block == blockA || block == blockB
        end
        end)
    end
  end
end
