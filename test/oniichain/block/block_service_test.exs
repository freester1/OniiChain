defmodule Oniichan.BlockServiceTest do
  use ExUnit.Case, async: false
  import Oniichain.TestUtil, only: [reset_db: 0]
  import Oniichain.BlockService, only: [create_next_block: 1, is_block_valid: 2, get_latest_block: 0, add_block: 1]

  setup do
    reset_db()
    :ok
  end

  describe "create_next_block" do
    test "creates a valid block" do
      block = create_next_block("blargh")
      assert is_block_valid(block, get_latest_block())
    end
  end

  describe "is_block_valid" do
    test "returns false if the new block has an invalid index" do
      block = create_next_block("blargh")
      block = %{block | index: 44}
      assert is_block_valid(block, get_latest_block()) == false
    end

    test "returns false if the new block has an invalid hash" do
      block = create_next_block("blargh")
      block = %{block | hash: "boo"}
      assert is_block_valid(block, get_latest_block()) == false
    end

    test "returns false if the new block has an invalid previous hash" do
      block = create_next_block("blargh")
      block = %{block | previous_hash: "boo"}
      assert is_block_valid(block, get_latest_block()) == false
    end
  end

  describe "get_latest_block" do
    test "gets whatever is keyed in as :latest" do
      block = create_next_block("blargh")
      :ets.insert(:latest_block, {:latest, block})
      assert get_latest_block() == block
    end
  end

  describe "add_block" do
    test "adds the given valid block as the new latest block and at that block index" do
      block = create_next_block("blargh")
      add_block(block)
      assert get_latest_block() == block
    end

    test "does not change the latest block if the given block is invalid" do
      block = create_next_block("blargh")
      block = %{block | previous_hash: "boo"}
      assert get_latest_block() != block
    end
  end
end
