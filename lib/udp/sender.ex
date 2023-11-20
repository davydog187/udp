defmodule UDP.Sender do
  use GenServer

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    source = Keyword.fetch!(opts, :source)
    destination = Keyword.fetch!(opts, :destination)
    name = Keyword.fetch!(opts, :name)

    Logger.info("Opening UDP socket on #{elem(source, 0)}:#{elem(source, 1)}")

    schedule_send()

    case :gen_udp.open(elem(source, 1), [:inet, ip: parse_host(elem(source, 0))]) do
      {:ok, socket} ->
        state = %{
          source: source,
          destination: destination,
          socket: socket,
          name: name,
          counter: 0
        }

        {:ok, state}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  def handle_info(:send_data, %{counter: counter, name: name} = state) do
    {host, port} = state.destination
    message = "#{name} #{state.counter}"
    Logger.info("Sending #{message} to #{host}:#{port}")

    case :gen_udp.send(state.socket, {parse_host(host), port}, message) do
      :ok ->
        schedule_send()
        {:noreply, %{state | counter: counter + 1}}

      {:error, reason} ->
        {:stop, reason, state}
    end
  end

  defp schedule_send, do: Process.send_after(self(), :send_data, :timer.seconds(3))

  defp parse_host(host) do
    host = to_charlist(host)

    case :inet.parse_address(host) do
      {:ok, host} ->
        host

      _ ->
        case :inet.getaddr(host, :inet) do
          {:ok, ip} -> ip
          _ -> raise "Could not get IP for #{host}"
        end
    end
  end
end
