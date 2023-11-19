defmodule UDP.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {UDP.Sender, port: 54321, name: System.get_env("NAME")}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Udp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
