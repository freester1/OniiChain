defmodule OniichainWeb.Router do
  use OniichainWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OniichainWeb do
    pipe_through :api # Use the default browser stack
    
    post "/mine_block", BlockController, :add_block
  end
end
