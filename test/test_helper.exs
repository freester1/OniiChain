ExUnit.start()

## reset ets
:ets.delete(:block_chain)
Oniichain.Application.initialize_datastore()
