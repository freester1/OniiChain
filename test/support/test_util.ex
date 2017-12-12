## reset ets
defmodule Oniichain.TestUtil do
  def reset_db() do
    :mnesia.clear_table(:block_chain)
    maybe_delete_ets_table(:peers)
    maybe_delete_ets_table(:latest_block)
    Oniichain.Application.initialize_datastore()
  end

  defp maybe_delete_ets_table(table) do
    if :ets.info(table) != :undefined do
      :ets.delete(table)
    end
    :ok
  end
end
