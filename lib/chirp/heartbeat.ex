defmodule Chirp.Heartbeat do
  use GenServer
  require Logger

  @impl true
  def handle_info(:beat, state) do
    schedule_beat()
    beat = state.beat + 1
    Phoenix.PubSub.broadcast(Chirp.PubSub, "beat", %{beat: beat})

    Logger.debug("Chirp.Heartbeat beat=#{beat}.")

    {:noreply, %{beat: beat}}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    schedule_beat()
    {:ok, %{beat: 0}}
  end

  defp schedule_beat() do
    Process.send_after(self(), :beat, 60 * 1_000)
  end
end
