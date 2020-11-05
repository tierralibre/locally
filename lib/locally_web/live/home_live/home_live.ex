defmodule LocallyWeb.HomeLive do
  use LocallyWeb, :live_view

  alias Locally.Market

  def mount(_params, _session, socket) do
    if connected?(socket) do
    end

    {
      :ok,
      socket
      |> assign(:product_list, list_products())
    }
  end

  defp list_products() do
    Market.list_products()
  end
end
