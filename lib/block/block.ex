defmodule Oniichain.Block do
    @moduledoc """
    Represents a block in a block chain
    """
    @fields [:index, :previous_hash, :timestamp, :data, :hash]
    @enforce_keys @fields
    defstruct @fields
end