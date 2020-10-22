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

    category =
      Map.from_struct(Enum.find(socket.assigns.categories, fn cat -> cat.name == category end))

    product_categories = Jason.decode!(product.categories)
    inserted_product_categories = [category | product_categories]

    {
      :noreply,
      assign(socket, :product, %Product{
        product
        | categories: Jason.encode!(inserted_product_categories)
      })
      |> assign(:show_category_dialog, false)
    }
  end

  def handle_event("delete-category", %{"category" => category}, socket) do
    product = socket.assigns.product
    category = Enum.find(socket.assigns.categories, fn cat -> cat.name == category end)

    deleted_product_categories =
      Jason.decode!(product.categories)
      |> Enum.map(fn cat -> deleted_category(cat, category.id) end)

    {
      :noreply,
      assign(socket, :product, %Product{
        product
        | categories: Jason.encode!(deleted_product_categories)
      })
      |> assign(:show_category_dialog, false)
    }
  end

  defp deleted_category(%{"id" => id} = category, id) do
    %{category | "deleted" => true}
  end

  defp deleted_category(category, _) do
    category
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
