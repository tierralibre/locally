defmodule LocallyWeb.StockLive.Index do
  use LocallyWeb, :live_view

  alias Locally.Market
  alias Locally.Market.Stock

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :stocks, list_stocks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Stock")
    |> assign(:stock, id |> split_id() |> Market.get_stock!())
  end

  defp split_id(id) do
    id |> String.split(",") |> Enum.map(&String.to_integer(&1))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Stock")
    |> assign(:stock, %Stock{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Stocks")
    |> assign(:stock, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    stock = Market.get_stock!(id)
    {:ok, _} = Market.delete_stock(stock)

    {:noreply, assign(socket, :stocks, list_stocks())}
  end

  defp list_stocks do
    Market.list_stocks()
  end
end
