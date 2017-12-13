defmodule Oniichain.ErrorAlreadyConnected do
  @moduledoc """
  Exception raised when attempting to connect to a user again.
  """
  defexception plug_status: 409, message: "Connection to this peer already established."
end
