# Oniichain

**TODO: Add description**
### Api so far:
```
add block:
curl -H 'Content-Type: application/json' localhost:4000/oniichain/v1/block -X POST -d '{"data": "cooldata"}'

get all blocks:
curl localhost:4000/oniichain/v1/blocks

add peer:
curl -H 'Content-Type: application/json' localhost:4000/oniichain/v1/peer -X POST -d '{"host": "127.0.0.1", "port": 5553}'

get all peers:
curl localhost:4000/oniichain/v1/peers
```
upon adding, connections between peers are established via websocket.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `oniichain` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:oniichain, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/oniichain](https://hexdocs.pm/oniichain).
