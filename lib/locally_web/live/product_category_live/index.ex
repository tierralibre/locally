defmodule LocallyWeb.ProductCategoryLive.Index do
  use LocallyWeb, :live_view

  alias Locally.Market
  alias Locally.Market.ProductCategory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :product_categories, list_product_categories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product category")
    |> assign(:product_category, Market.get_product_category!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product category")
    |> assign(:product_category, %ProductCategory{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Product categories")
    |> assign(:product_category, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product_category = Market.get_product_category!(id)
    {:ok, _} = Market.delete_product_category(product_category)

    {:noreply, assign(socket, :product_categories, list_product_categories())}
  end

  defp list_product_categories do
    Market.list_product_categories()
  end
end
