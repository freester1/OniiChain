defmodule Oniichain.BlockService do
  require Logger
  @moduledoc """
  Operations for blocks
  """

  # creates a new block based on the latest one
  def create_next_block(data) do
    latest_block = get_latest_block()
    index        = latest_block.index + 1
    timestamp    = :os.system_time(:seconds)
    hash         = generate_block_hash(index, latest_block.hash, timestamp, data)      
    %Oniichain.Block{
      index: index,
      previous_hash: latest_block.hash,
      timestamp: timestamp,
      data: data,
      hash: hash
    }
  end

  def is_block_valid(new_block, previous_block) do
    if new_block.index - 1 != previous_block.index
    || new_block.previous_hash != previous_block.hash
    || generate_hash_from_block(new_block) != new_block.hash do
        Logger.debug("Invalid block new_block: #{inspect new_block} prev_block: #{inspect previous_block}")
        false
    else
        true
    end
  end

  def add_block(block) do
    if is_block_valid(block, get_latest_block()) do
        :ets.insert(:block_chain, {:latest, block})
    end
  end

  def get_latest_block() do
    :ets.lookup(:block_chain, :latest) |> hd |> elem(1)
  end

  defp generate_hash_from_block(block) do
    generate_block_hash(block.index, block.previous_hash, block.timestamp, block.data)
  end

  # generates a block hash
  defp generate_block_hash(index, previous_hash, timestamp, data) do
    :crypto.hash(:sha256, "#{index}#{previous_hash}#{timestamp}#{data}")
    |> Base.encode64
  end
end