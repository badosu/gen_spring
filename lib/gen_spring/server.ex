defmodule GenSpring.Server do
  @moduledoc """
  """

  use Supervisor

  @impl Supervisor
  def init(options) do
    children = [
      {DynamicSupervisor, server_supervisor_options(options)},
      {ThousandIsland, transport_options(options)}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end

  def start_link(config) do
    supervisor_options = Keyword.get(config, :supervisor_options, [])
    Supervisor.start_link(__MODULE__, config, supervisor_options)
  end

  def start_child(GenSpring.Handler, buffer, handler_module, handler_opts) do
    {supervisor, handler_opts} =
      Keyword.pop(handler_opts, :supervisor, GenSpring.Handler.Supervisor)

    child_spec =
      Supervisor.child_spec(
        {GenSpring.Handler, buffer: buffer, server: {handler_module, handler_opts}},
        []
      )

    DynamicSupervisor.start_child(supervisor, child_spec)
  end

  defp server_supervisor_options(options) do
    {_module, server_options} = Keyword.fetch!(options, :server)
    supervisor_name = Keyword.get(server_options, :supervisor, GenSpring.Handler.Supervisor)

    [name: supervisor_name, strategy: :one_for_one]
  end

  @default_thousand_island_options [
    port: 9090,
    transport_options: [packet: :line],
    handler_module: GenSpring.Communication.Transport
  ]
  defp transport_options(options) do
    server_options = Keyword.fetch!(options, :server)
    transport_options = Keyword.get(options, :transport, [])

    @default_thousand_island_options
    |> Keyword.merge(transport_options)
    |> Keyword.merge(handler_options: [server: server_options])
  end
end
