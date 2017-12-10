defmodule OniichainWeb.ErrorView do
  use OniichainWeb, :view

  def render("404.json", _assigns) do
    %{}
  end

  def render("500.json", _assigns) do
    %{}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
