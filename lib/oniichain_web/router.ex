defmodule OniichainWeb.Router do
  use OniichainWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/oniichain/v1", OniichainWeb do
    pipe_through :api # Use the default browser stack

    post "/block", BlockController, :add_block
    get "/blocks", BlockController, :get_all_blocks

    post "/peer", PeerController, :add_peer
  end
end
