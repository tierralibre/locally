defmodule LocallyWeb.StockLive.Index do
  use LocallyWeb, :live_view

  alias Locally.Market
  alias Locally.Market.Stock
  alias Locally.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    store_options = store_options(user.id)
    store_selected = first_store(store_options)

    {
      :ok,
      socket
      |> assign(:stocks, list_stocks(store_selected))
      |> assign(:store_selected, store_selected)
      |> assign(:stores, store_options)
      |> assign(:products, list_products())
    }
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
    stock = Market.get_stock!(id |> split_id())
    {:ok, _} = Market.delete_stock(stock)

    {:noreply, assign(socket, :stocks, list_stocks(socket.assigns.store_selected))}
  end

  def handle_event("store_selected", %{"store_selected" => store_selected}, socket) do
    {
      :noreply,
      socket
      |> assign(:store_selected, store_selected)
      |> assign(:stocks, list_stocks(store_selected))
    }
  end

  defp list_stocks(store_id) do
    Market.list_stocks_by_store(store_id)
  end

  defp store_options(owner_id) do
    owner_id
    |> list_stores()
    |> Enum.map(fn store -> {store.name, store.id} end)
  end

  defp list_stores(owner_id) do
    Market.list_stores([{"owner_id", owner_id}])
  end

  defp split_id(id) do
    id |> String.split(",")
  end

  defp first_store([]) do
    nil
  end

  defp first_store(store_options) do
    store_options |> List.first() |> elem(1)
  end

  defp list_products() do
    Market.list_products()
  end
end
