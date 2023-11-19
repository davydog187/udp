defmodule UDP.Sender do
  use GenServer

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    port = Keyword.fetch!(opts, :port)
    name = Keyword.fetch!(opts, :name)

    Logger.info("Opening UDP socket on port #{port}")

    schedule_send()

    case :gen_udp.open(port) do
      {:ok, socket} -> {:ok, %{port: port, socket: socket, name: name, counter: 0}}
      {:error, reason} -> {:stop, reason}
    end
  end

  def handle_info(:send_data, %{counter: counter, name: name} = state) do
    case :gen_udp.send(state.socket, Jason.encode!(%{name: name, counter: counter})) do
      :ok ->
        schedule_send()
        {:noreply, %{state | counter: counter + 1}}
      {:error, reason} -> {:stop, reason, state}
    end
  end

  defp schedule_send, do: Process.send_after(self(), :send_data, :timer.seconds(3))
end
