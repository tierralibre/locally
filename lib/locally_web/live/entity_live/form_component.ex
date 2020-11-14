defmodule LocallyWeb.EntityLive.FormComponent do
  use LocallyWeb, :live_component

  alias Locally.Era

  @impl true
  def update(%{entity: entity} = assigns, socket) do
    changeset = Era.change_entity(entity)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"entity" => entity_params}, socket) do
    changeset =
      socket.assigns.entity
      |> Era.change_entity(entity_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"entity" => entity_params}, socket) do
    IO.puts "handle_event save"
    IO.inspect socket
    save_entity(socket, socket.assigns.action, entity_params)
  end

  defp save_entity(socket, :edit, entity_params) do
    IO.puts "save_entity :edit"
    IO.inspect socket
    case Era.update_entity(socket.assigns.entity, entity_params) do
      {:ok, _entity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entity updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_entity(socket, :new, entity_params) do
    IO.puts "save_entity :new"

    current_user = Locally.Accounts.get_user_by_session_token(socket.assigns.user_token)
    IO.inspect current_user
    case Era.create_entity(current_user, entity_params) do
      {:ok, _entity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entity created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
