defmodule OniichainWeb.BlockController do
  use OniichainWeb, :controller

  def index(conn, _params) do
    render(conn, "200.json", %{})
  end
end
