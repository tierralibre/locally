defmodule LocallyWeb.ProductLive.FormComponent do
  use LocallyWeb, :live_component

  alias Locally.Market
  alias Locally.Market.Product

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Market.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Market.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  def handle_event("show-category-dialog", %{}, socket) do
    {:noreply, assign(socket, :show_category_dialog, not socket.assigns.show_category_dialog)}
  end

  def handle_event("add-category", %{"category" => category}, socket) do
    product = socket.assigns.product
    category = Enum.find(socket.assigns.categories, fn cat -> cat.name == category end)

    {
      :noreply,
      assign(socket, :product, %Product{product | categories: [category | product.categories]})
      |> assign(:show_category_dialog, false)
    }
  end

  def handle_event("delete-category", %{"category" => category}, socket) do
    product = socket.assigns.product
    category = Enum.find(socket.assigns.categories, fn cat -> cat.name == category end)

    {
      :noreply,
      assign(socket, :product, %Product{
        product
        | categories: Enum.filter(product.categories, fn cat -> cat.name != category.name end)
      })
      |> assign(:show_category_dialog, false)
    }
  end

  defp save_product(socket, :edit, product_params) do
    case Market.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Market.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
