defmodule LocallyWeb.ProductLive.Index do
  use LocallyWeb, :live_view

  alias Locally.Market
  alias Locally.Market.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :products, list_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Market.get_product_with_categories!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{categories: "[]"})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
    |> assign(:categories, Market.list_product_categories())
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Market.get_product!(id)
    {:ok, _} = Market.delete_product(product)

    {:noreply, assign(socket, :products, list_products())}
  end

  defp list_products do
    Market.list_products()
  end
end
