## reset ets
defmodule Oniichain.TestUtil do
  def reset_db() do
    if :ets.info(:block_chain) != :undefined do
      :ets.delete(:block_chain)
    end
    Oniichain.Application.initialize_datastore()
  end
end