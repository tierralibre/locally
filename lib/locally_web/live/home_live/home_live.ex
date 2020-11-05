defmodule LocallyWeb.HomeLive do
  use LocallyWeb, :live_view

  alias Locally.Market

  def mount(params, _session, socket) do
    if connected?(socket) do
    end

    {
      :ok,
      socket
      |> assign(:product_list, list_products(params))
    }
  end

  defp list_products(%{"search" => search_text}) do
    Market.search_products(search_text)
  end

  defp list_products(_params) do
    Market.list_products()
  end
end
