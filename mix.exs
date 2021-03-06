defmodule Oniichain.Mixfile do
  use Mix.Project

  def project do
    [
      app: :oniichain,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls":        :test,
        "coveralls.detail": :test,
        "coveralls.post":   :test,
        "coveralls.html":   :test
      ],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Oniichain.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:ksuid, "~> 0.1.2"},
      {:phoenix_gen_socket_client, "~> 2.0.0"},
      {:websocket_client, "~> 1.2"},
      {:poison, "~> 2.0"},
      {:excoveralls, "~> 0.7", only: :test}
    ]
  end
  defp aliases do
    []
  end
end
