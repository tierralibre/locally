defmodule LocallyWeb.TransactionInputsComponent do
  use LocallyWeb, :live_component

  def mount(socket) do
    socket =
      assign(socket,
        inputs: [],
        search_phrase: "test",
        search_results: [],
        current_focus: -1
      )

    {:ok, socket}
  end

  # def update(assigns, socket) do
  #   {:ok, assign(socket, assigns)}
  # end

  def render(assigns) do
    ~L"""
    <form>
      <div class="py-2 px-3 bg-white border border-gray-400" phx-window-keydown="set-focus" phx-target="<%= @myself %>">
        <%= for input <- @inputs do %>
          <span class="inline-block text-xs bg-green-400 text-white py-1 px-2 mr-1 mb-1 rounded">
            <span><%= input.name %></span>
            <a href="#" class="text-white hover:text-white" phx-click="delete" phx-value-tagging="<%= input.id %>">&times</a>
          </span>
        <% end %>
        <input
          type="text"
          class="inline-block text-sm focus:outline-none"
          name="search_phrase"
          value="<%= @search_phrase %>"
          phx-debounce="500"
          phx-change="search"
          phx-target="<%= @myself %>"
          placeholder="Add input">

      </div>
      <%= if @search_results != [] do %>
        <div class="relative">
          <div class="absolute z-50 left-0 right-0 rounded border border-gray-100 shadow py-1 bg-white">
            <%= for {search_result, idx} <- Enum.with_index(@search_results) do %>
              <div class="cursor-pointer p-2 hover:bg-gray-200 focus:bg-gray-200 <%= if idx == @current_focus, do: 'bg-gray-200' %>" phx-click="pick" phx-value-name="<%= search_result %>">
                <%= raw format_search_result(search_result, @search_phrase) %>
              </div>
            <% end %>
          </div>
        </div>
      <% end %>
    </form>
    """
  end

  def handle_event("search", %{"search_phrase" => search_phrase}, socket) do
    IO.puts "search"

    {:noreply, socket}
  end

  def handle_event(event, params, socket) do
    {:noreply, socket}
  end

  defp format_search_result(search_result, search_phrase) do
    split_at = String.length(search_phrase)
    {selected, rest} = String.split_at(search_result, split_at)

    "<strong>#{selected}</strong>#{rest}"
  end
end
