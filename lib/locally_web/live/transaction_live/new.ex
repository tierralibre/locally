defmodule LocallyWeb.TransactionLive.New do
  use LocallyWeb, :live_view

  alias LocallyWeb.TransactionLive.Step
  alias Locally.Era
  alias Locally.Era.Transaction

  # step actions? same linked?
  @steps [
    %Step{name: "who", prev: nil, next: "what"},
    %Step{name: "what", prev: "who", next: "when"},
    %Step{name: "when", prev: "what", next: "where"},
    %Step{name: "where", prev: "when", next: "why"},
    %Step{name: "why", prev: "when", next: nil}
  ]

  @impl true
  def mount(_params, %{"user_token" => user_token} = _session, socket) do
    first_step = List.first(@steps)
    current_user = Locally.Accounts.get_user_by_session_token(user_token)
    transaction = %Transaction{}
    params = %{creator_id: current_user}
    changeset = Era.change_transaction(transaction, params)

    socket =
      assign(socket, :progress, first_step)
      |> assign(:transaction, transaction)
      |> assign(:params, params)
      |> assign(:changeset, changeset)
      |> assign(:current_user, current_user)
      |> assign(:inputs, [])
      |> assign(:outputs, [])

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="container">
      <div class='<%= unless @progress.name == "who", do: "hidden" %>'>
        <%= live_component @socket, LocallyWeb.WhoComponent,
          id: "who",
          transaction: @transaction,
          current_user: @current_user
        %>
      </div>

      <div class='<%= unless @progress.name == "what", do: "hidden" %>'>
        <%= live_component @socket, LocallyWeb.WhatComponent, id: "what", transaction: @transaction%>
      </div>

      <div class='<%= unless @progress.name == "when", do: "hidden" %>'>
        <%= live_component @socket, LocallyWeb.WhenComponent,
          id: "when",
          transaction: @transaction,
          current_user: @current_user
        %>
      </div>

      <div class='<%= unless @progress.name == "where", do: "hidden" %>'>
        <%= live_component @socket, LocallyWeb.WhereComponent,
          id: "where",
          transaction: @transaction
        %>
      </div>

      <div class='<%= unless @progress.name == "why", do: "hidden" %>'>
        <%= live_component @socket, LocallyWeb.WhyComponent,
          id: "why",
          submit_text: "Create",
          transaction: @transaction
        %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_params(params, _url, socket) do
    # {:noreply, apply_action(socket, socket.assigns.live_action, params)}
    {:noreply, socket}
  end

  def handle_info({:proceed, %LocallyWeb.WhoComponent{} = form}, socket) do
    params = %{}

    {:noreply,
     socket
     |> assign(:params, Map.merge(socket.assigns.params, params))
     |> assign(:inputs, socket.assigns.inputs ++ [form])
     |> assign_step(:next)}
  end

  def handle_info({:proceed, %LocallyWeb.WhatComponent{} = form}, socket) do
    params = %{}

    {:noreply,
     socket
     |> assign(:params, Map.merge(socket.assigns.params, params))
     |> assign(:inputs, socket.assigns.inputs ++ [form])
     |> assign_step(:next)}
  end

  def handle_info({:proceed, %LocallyWeb.WhenComponent{} = form}, socket) do
    params = %{}

    {:noreply,
     socket
     |> assign(:params, Map.merge(socket.assigns.params, params))
     |> assign(:inputs, socket.assigns.inputs ++ [form])
     |> assign_step(:next)}
  end

  def handle_info({:proceed, %LocallyWeb.WhereComponent{} = form}, socket) do
    params = %{}

    {:noreply,
     socket
     |> assign(:params, Map.merge(socket.assigns.params, params))
     |> assign(:inputs, socket.assigns.inputs ++ [form])
     |> assign_step(:next)}
  end

  def handle_info({:proceed, %LocallyWeb.WhyComponent{} = form}, socket) do
    params = %{}

    {:noreply,
     socket
     |> assign(:params, Map.merge(socket.assigns.params, params))
     |> assign(:inputs, socket.assigns.inputs ++ [form])
     |> assign_step(:next)}
  end

  defp assign_step(socket, step) do
    if new_step = Enum.find(@steps, &(&1.name == Map.get(socket.assigns.progress, step))) do
      assign(socket, :progress, new_step)
    else
      # save
      step = %Step{name: "", prev: nil, next: nil}
      socket = assign(socket, :progress, step)
      |> assign(:outputs, socket.assigns.inputs)
      IO.inspect socket.assigns.outputs
      socket
    end
  end
end
