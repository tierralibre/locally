defmodule LocallyWeb.WhyComponent do
  use LocallyWeb, :live_component

  use Ecto.Schema
  import Ecto.Changeset

  @required [:name]
  @params [:name]

  embedded_schema do
    field :name, :string
  end

  @doc false
  def changeset(who, attrs) do
    who
    |> cast(attrs, @params)
    |> validate_required(@required)
  end

  def mount(socket) do
    why_changeset = changeset(%__MODULE__{}, %{})

    socket =
      assign(socket,
        inputs: [],
        why_changeset: why_changeset,
        why: %__MODULE__{}
      )

    {:ok, socket}
  end

  # def update(assigns, socket) do
  #   {:ok, assign(socket, assigns)}
  # end

  def render(assigns) do
    ~L"""
    <h3>Why</h3>
    <%= f = form_for @why_changeset, "#",
      phx_change: :validate,
      phx_target: @myself,
      phx_submit: :save,
      id: @id %>

      <%= label f, :name %>
      <%= text_input f, :name %>
      <%= error_tag f, :name %>
    </form>
    """
  end

  def handle_event("save", %{"why_component" => params}, socket) do
    socket.assigns.why
    |> changeset(params)
    |> Ecto.Changeset.apply_action(:insert)
    |> case do
      {:ok, record} ->
        IO.puts ":ok, record"
        send(self(), {:proceed, record})
        {:noreply, socket}

      {:error, changeset} ->
        IO.puts ":error, changeset"
        IO.inspect changeset
        {:noreply,
         socket
         |> assign(:who_changeset, changeset)}
    end
  end

  def handle_event(event, params, socket) do
    IO.puts("event")
    IO.inspect(event)
    IO.inspect(params)
    {:noreply, socket}
  end
end
