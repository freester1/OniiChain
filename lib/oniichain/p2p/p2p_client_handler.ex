defmodule Oniichain.P2pClientHandler do
  @moduledoc """
  Receives and handles messages over websocket.
  Responsible for keeping the block chain in sync.
  """
  require Logger
  alias Phoenix.Channels.GenSocketClient
  @behaviour GenSocketClient

  # can't inherit attributes and use them inside matches, so this is necessary
  @query_latest_block Oniichain.P2pMessage.query_latest_block
  @query_all_blocks   Oniichain.P2pMessage.query_all_blocks
  @update_block_chain Oniichain.P2pMessage.update_block_chain
  @add_peer_request   Oniichain.P2pMessage.add_peer_request
  @connection_error   Oniichain.P2pMessage.connection_error
  @connection_success Oniichain.P2pMessage.connection_success

  def start_link(host, port) do
    GenSocketClient.start_link(
          __MODULE__,
          Phoenix.Channels.GenSocketClient.Transport.WebSocketClient,
          "ws://#{host}:#{port}/p2p/websocket"
        )
  end

  def init(url) do
    {:connect, url, [], %{}}
  end

  def handle_connected(transport, state) do
    Logger.info("connected")
    GenSocketClient.join(transport, "p2p")
    {:ok, state}
  end

  def handle_disconnected(reason, state) do
    Logger.error("disconnected: #{inspect reason}. Attempting to reconnect...")
    Process.send_after(self(), :connect, :timer.seconds(1))
    {:ok, state}
  end

  def handle_joined(topic, _payload, _transport, state) do
    Logger.info("joined the topic #{topic}. Attempting to get client connection from remote host...")
    Process.send(self(), @add_peer_request, [])
    {:ok, state}
  end

  def handle_join_error(topic, payload, _transport, state) do
    Logger.error("join error on the topic #{topic}: #{inspect payload}")
    {:ok, state}
  end

  def handle_channel_closed(topic, payload, _transport, state) do
    Logger.error("disconnected from the topic #{topic}: #{inspect payload}. Attempting to rejoin...")
    Process.send_after(self(), {:join, topic}, :timer.seconds(2))
    {:ok, state}
  end

  def handle_message(topic, event, payload, _transport, state) do
    Logger.info("message on topic #{topic}: #{event} #{inspect payload}")
    {:ok, state}
  end

  def handle_reply("p2p", _ref, %{"response" => %{"type" => @connection_success}}, _transport, state) do
    Logger.info("server ack ##{inspect payload["response"]}")
    {:ok, state}
  end

  def handle_reply("p2p", _ref, %{"response" => %{"type" => @connection_error}}, _transport, state) do
    Logger.info("connection to server failed...")
    # alert session manager to kill self
    {:ok, state}
  end

  def handle_reply(topic, _ref, payload, _transport, state) do
    Logger.warn("reply on topic #{topic}: #{inspect payload}")
    {:ok, state}
  end

  def handle_info(:connect, _transport, state) do
    Logger.info("connecting")
    {:connect, state}
  end

  def handle_info({:join, topic}, transport, state) do
    Logger.info("joining the topic #{topic}")
    case GenSocketClient.join(transport, topic) do
      {:error, reason} ->
        Logger.error("error joining the topic #{topic}: #{inspect reason}. Attempting to rejoin...")
        Process.send_after(self(), {:join, topic}, :timer.seconds(1))
      {:ok, _ref} -> :ok
    end

    {:ok, state}
  end

  def handle_info(@query_latest_block, transport, state) do
    Logger.info("quering for latest blocks")
    GenSocketClient.push(transport, "p2p", @query_latest_block, %{})
    {:ok, state}
  end

  def handle_info(@query_all_blocks, transport, state) do
    Logger.info("querying for all blocks")
    GenSocketClient.push(transport, "p2p", @query_all_blocks, %{})
    {:ok, state}
  end

  def handle_info(@add_peer_request, transport, state) do
    Logger.info("sending request to add me as a peer")
    local_server_host = Application.get_env(:oniichain, OniichainWeb.Endpoint)[:url][:host]
    local_server_port = Application.get_env(:oniichain, OniichainWeb.Endpoint)[:http][:port]
    GenSocketClient.push(transport, "p2p", @add_peer_request, %{host: local_server_host, port: local_server_port})
    {:ok, state}
  end

  def handle_info(message, _transport, state) do
    Logger.warn("Unhandled message #{inspect message}")
    {:ok, state}
  end
end
