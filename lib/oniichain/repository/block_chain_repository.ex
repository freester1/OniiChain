defmodule Oniichain.BlockChainRepository do
  @moduledoc """
    Defines functionality for interacting with the block chain
    mnesia table
  """

  def insert_block(block) do
    {:atomic, :ok} = :mnesia.transaction(fn ->
      :mnesia.write({:block_chain,
        block.index,
        block.previous_hash,
        block.timestamp,
        block.data,
        block.hash})
    end)
    :ok
  end

  def get_all_blocks() do
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.foldl(fn(record, acc) ->
        [deserialize_block_from_record(record) | acc]
      end, [], :block_chain)
    end)
    result
  end

  def replace_chain(block_chain, latest_block) do
    :mnesia.transaction(fn ->
      block_chain
      |> Enum.each(fn(block) ->
        insert_block(block)
      end)
    end)
    :ets.insert(:latest_block, {:latest, latest_block})
  end

  def deserialize_block_from_record(record) do
    %Oniichain.Block{
      index:         elem(record, 1),
      previous_hash: elem(record, 2),
      timestamp:     elem(record, 3),
      data:          elem(record, 4),
      hash:          elem(record, 5)
    }
  end
end
