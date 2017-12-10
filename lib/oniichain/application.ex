defmodule Oniichain.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # List all child processes to be supervised
    children = [
      supervisor(OniichainWeb.Endpoint, []),
      # Starts a worker by calling: Test.Worker.start_link(arg)
      # {Test.Worker, arg},
    ]

    initialize_datastore()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Oniichain.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    OniichainWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def initialize_datastore() do
    :ets.new(:block_chain, [:set, :public, :named_table])
    generate_initial_block()
  end

  defp generate_initial_block() do
    init_block = %Oniichain.Block{
      index: 0,
      previous_hash: "0",
      timestamp: :os.system_time(:seconds),
      data: "foofizzbazz",
      hash: :crypto.hash(:sha256, "cool") |> Base.encode64
    }
    :ets.insert(:block_chain, {0, init_block})
    :ets.insert(:block_chain, {:latest, init_block})
  end
end