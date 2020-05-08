defmodule ChirpWeb.HeartbeatLive do
  use ChirpWeb, :live_view
  require Logger

  @impl true
  def render(assigns) do
    ~L"""
      <div>
        Hello World
      </div>
    """
  end

  @impl true
  def handle_info(%{beat: count}, socket) do
    Logger.debug("ChirpWeb.HeartbeatLive beat=#{count}")
    {:noreply, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    {:ok, socket}
  end

  defp subscribe() do
    Phoenix.PubSub.subscribe(Chirp.PubSub, "beat")
  end
end
