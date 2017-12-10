defmodule OniichainWeb.BlockView do
    use OniichainWeb, :view

    def render("200.json", %{}) do
      %{}
    end

    def render("blocks.json", %{blocks: blocks}) do
      %{blocks: blocks}
    end
  end
