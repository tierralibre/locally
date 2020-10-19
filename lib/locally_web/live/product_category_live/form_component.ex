defmodule LocallyWeb.ProductCategoryLive.FormComponent do
  use LocallyWeb, :live_component

  alias Locally.Market

  @impl true
  def update(%{product_category: product_category} = assigns, socket) do
    changeset = Market.change_product_category(product_category)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"product_category" => product_category_params}, socket) do
    changeset =
      socket.assigns.product_category
      |> Market.change_product_category(product_category_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product_category" => product_category_params}, socket) do
    save_product_category(socket, socket.assigns.action, product_category_params)
  end

  defp save_product_category(socket, :edit, product_category_params) do
    case Market.update_product_category(socket.assigns.product_category, product_category_params) do
      {:ok, _product_category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product category updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product_category(socket, :new, product_category_params) do
    case Market.create_product_category(product_category_params) do
      {:ok, _product_category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product category created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
