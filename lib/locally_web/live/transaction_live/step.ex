defmodule LocallyWeb.TransactionLive.Step do
  @moduledoc "Describe a step in the transaction."
  defstruct [:name, :prev, :next]
end
