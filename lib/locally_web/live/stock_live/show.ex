defmodule LocallyWeb.StockLive.Show do
  use LocallyWeb, :live_view

  alias Locally.Market

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:stock, id |> split_id() |> Market.get_stock!())}
  end

  defp split_id(id) do
    id |> String.split(",") |> Enum.map(&String.to_integer(&1))
  end

  defp page_title(:show), do: "Show Stock"
  defp page_title(:edit), do: "Edit Stock"
end
