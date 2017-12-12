# Oniichain

**TODO: Add description**
## Setup
get dependencies
```
mix deps.get
```
initialize database (only need to do this once)
```
mix init_db
```
run phoenix (port env var optional)
```
PORT=4444 mix phx.server
```

code coverage
```
mix coveralls
```

## Api so far:
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
