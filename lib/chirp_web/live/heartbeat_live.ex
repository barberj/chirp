defmodule ChirpWeb.HeartbeatLive do
  use ChirpWeb, :live_view
  require Logger

  @impl true
  def render(assigns) do
    ~L"""
      <div>
        Hello World <%= @beats %>
      </div>
    """
  end

  @impl true
  def handle_info(%{beat: count}, socket) do
    Logger.debug("ChirpWeb.HeartbeatLive beat=#{count}")
    {:noreply, update(socket, :beats, fn _ -> count end)}
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    {:ok, assign(socket, :beats, 0)}
  end

  defp subscribe() do
    Phoenix.PubSub.subscribe(Chirp.PubSub, "beat")
  end
end
