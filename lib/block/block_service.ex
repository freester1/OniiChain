defmodule Oniichain.BlockService do
    @moduledoc """
    Operations for blocks
    """

    # adds a new block with the given data to the chain
    def add_block(data) do
        
    end

    # generates a block hash
    defp generate_block_hash(index, previous_hash, timestamp, data) do
        :crypto.hash()
    end
end