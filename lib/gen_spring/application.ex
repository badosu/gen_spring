defmodule GenSpring.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: GenSpring.Worker.start_link(arg)
      {ThousandIsland, port: 1234, handler_module: GenSpring.Communication.Handler}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GenSpring.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
