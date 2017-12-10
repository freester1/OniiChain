defmodule OniichainWeb.PageController do
  use OniichainWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
