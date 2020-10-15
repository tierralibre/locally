defmodule LocallyWeb.StoreLive.Index do
  use LocallyWeb, :live_view

  alias Locally.Market
  alias Locally.Market.Store

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :stores, list_stores())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Store")
    |> assign(:store, Market.get_store!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Store")
    |> assign(:store, %Store{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Stores")
    |> assign(:store, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    store = Market.get_store!(id)
    {:ok, _} = Market.delete_store(store)

    {:noreply, assign(socket, :stores, list_stores())}
  end

  defp list_stores do
    Market.list_stores()
  end
end
