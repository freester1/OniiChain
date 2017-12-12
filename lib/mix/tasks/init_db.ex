defmodule Mix.Tasks.InitDb do
  use Mix.Task
  @moduledoc """
    initializes the on-disk database and creates necessary tables.
  """
  def run(_args) do
    node = Node.self()
    Node.start(node)

    IO.puts("Initializing Mnesia DB on #{node}...")
    initialize_db(node)
    :ok
  end

  def initialize_db(node) do
    :mnesia.create_schema([node])
    :mnesia.start()

    create_block_chain_table(node)
    IO.puts("Successfully created tables.")
  end

  defp create_block_chain_table(node) do
    :ok = case :mnesia.create_table(:block_chain, [
      attributes: [:index, :previous_hash, :timestamp, :data, :hash],
      type: :set,
      disc_copies: [node]
    ]) do
      {:atomic, :ok} ->
        :ok
      {:aborted, {:already_exists, _}} ->
        :ok
      {:aborted, _} ->
        :abort
    end
    :ok = :mnesia.wait_for_tables([:block_chain], 5000)
  end
end
