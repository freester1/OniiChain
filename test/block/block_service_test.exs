defmodule Oniichan.BlockServiceTest do
    use ExUnit.Case, async: false
    import Oniichain.BlockService, only: [create_next_block: 1, is_block_valid: 2, get_latest_block: 0]
    
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
end
  