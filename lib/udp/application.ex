defmodule UDP.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      case System.get_env("TYPE") do
        "sender" ->
          {UDP.Sender,
           source: {source_host(), source_port()},
           destination: {destination_host(), destination_port()},
           name: System.get_env("NAME")}

        "receiver" ->
          {UDP.Receiver, host: host(), port: port()}

        _ ->
          raise "env var TYPE must be set as 'sender' or 'receiver'"
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Udp.Supervisor]
    Supervisor.start_link(List.wrap(children), opts)
  end

  defp source_host do
    System.get_env("SOURCE_HOST", "127.0.0.1")
  end

  defp source_port do
    String.to_integer(System.get_env("SOURCE_PORT", "5001"))
  end

  defp destination_host do
    System.get_env("DESTINATION_HOST", "127.0.0.1")
  end

  defp destination_port do
    String.to_integer(System.get_env("DESTINATION_PORT", "5002"))
  end

  defp host do
    System.get_env("HOST", "127.0.0.1")
  end

  defp port do
    String.to_integer(System.get_env("PORT", "5002"))
  end
end
