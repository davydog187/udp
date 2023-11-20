defmodule UDP.Receiver do
  use GenServer

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    host = Keyword.fetch!(opts, :host)
    port = Keyword.fetch!(opts, :port)

    Logger.info("Listening on UDP socket #{host}:#{port}")

    case :gen_udp.open(port, [:inet, ip: parse_host(host)]) do
      {:ok, socket} ->
        {:ok, %{socket: socket}}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  def handle_info({:udp, _port, ip, port, message}, state) do
    Logger.info(
      "Received message #{inspect(to_string(message))} from #{format_address(ip, port)}"
    )

    {:noreply, state}
  end

  defp format_address(ip, port) do
    "#{:inet.ntoa(ip)}:#{port}"
  end

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
