defmodule LocallyWeb.StoreLive.Index do
  use LocallyWeb, :live_view

  alias Locally.Market
  alias Locally.Accounts
  alias Locally.Market.Store

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    {
      :ok,
      socket
      |> assign(:stores, list_stores(user.id))
      |> assign(:current_user, user)
    }
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
    |> assign(:store, %Store{owner_id: socket.assigns.current_user.id})
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

    {:noreply, assign(socket, :stores, list_stores(socket.assigns.current_user.id))}
  end

  defp list_stores(owner_id) do
    Market.list_stores([{"owner_id", owner_id}])
  end
end
