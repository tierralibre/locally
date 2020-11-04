defmodule LocallyWeb.StockLive.FormComponent do
  use LocallyWeb, :live_component

  alias Locally.Market

  @impl true
  def update(%{stock: stock} = assigns, socket) do
    changeset = Market.change_stock(stock)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event(
        "validate",
        %{"stock" => %{"product_name" => product_name} = stock_params},
        socket
      ) do
    changeset =
      socket.assigns.stock
      |> Market.change_stock(stock_params)
      |> Map.put(:action, :validate)

    {
      :noreply,
      socket
      |> assign(:changeset, changeset)
      |> assign_product_candidates(product_name)
    }
  end

  def handle_event("save", %{"stock" => stock_params}, socket) do
    save_stock(socket, socket.assigns.action, stock_params)
  end

  defp save_stock(socket, :edit, stock_params) do
    case Market.update_stock(socket.assigns.stock, stock_params) do
      {:ok, _stock} ->
        {:noreply,
         socket
         |> put_flash(:info, "Stock updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_stock(socket, :new, stock_params) do
    case Market.create_stock(stock_params) do
      {:ok, _stock} ->
        {:noreply,
         socket
         |> put_flash(:info, "Stock created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp assign_product_candidates(socket, product_name) do
    product = socket.assigns.products |> Enum.find(fn prod -> prod.name == product_name end)

    case product do
      nil ->
        socket

      _ ->
        socket
        |> assign(
          :changeset,
          socket.assigns.changeset
          |> Ecto.Changeset.put_change(:to, product.id)
        )
    end
  end
end
