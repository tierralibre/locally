defmodule LocallyWeb.HomeLive do
  use LocallyWeb, :live_view


  def mount(_params, _session, socket) do
    if connected?(socket) do
    end

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Locally Dashboard</h1>
    """
  end
end
