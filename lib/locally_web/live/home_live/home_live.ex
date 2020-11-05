defmodule LocallyWeb.HomeLive do
  use LocallyWeb, :live_view

  alias Locally.Market
  alias Locally.Market.Product

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
    Market.search_products("")
  end

  def best_price(%Product{stock: []}) do
    "No stock"
  end

  def best_price(%Product{stock: stocks}) do
    case Enum.min_by(stocks, fn stock -> stock.price end) do
      nil -> "No stock"
      min -> min.price
    end
  end
end
