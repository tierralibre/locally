defmodule LocallyWeb.HomeLive do
  use LocallyWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
    end

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="cont-wrap">
      <h1>Locally Dashboard</h1>
      Working in favor of thriving local markets.
    </div>
    """
  end
end
