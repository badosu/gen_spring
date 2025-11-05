defmodule GenSpring.Communication.TransportTest do
  alias GenSpring.Communication.Buffer
  use ExUnit.Case

  require TraceHelper

  setup(options) do
    start_link_supervised!(GenSpring.Application.buffer_supervisor_child_spec())

    [tracer: TraceHelper.setup(options), transport: start_transport()]
  end

  test "connects to a buffer", options do
    port = options.transport.port
    :gen_tcp.connect(:localhost, port, active: false)

    SupervisorHelper.await_child!(GenSpring.BufferSupervisor)
  end

  @tag :trace
  test "greets the world", options do
    tracer = Map.fetch!(options, :tracer)
    transport = Map.fetch!(options, :transport)

    {:ok, client} = :gen_tcp.connect(:localhost, transport.port, active: false)

    buffer_pid = SupervisorHelper.await_child!(GenSpring.BufferSupervisor) |> elem(1)

    TraceHelper.trace_calls(tracer, buffer_pid, Buffer)

    :gen_tcp.send(client, "Hello")
    :gen_tcp.send(client, " Wor")
    :gen_tcp.send(client, "ld\nMerry\n")
    :gen_tcp.send(client, "Christmas\n")

    assert_incoming(tracer, "Hello World")
    assert_incoming(tracer, "Merry")
    assert_incoming(tracer, "Christmas")
  end

  defp assert_incoming(tracer, message) do
    TraceHelper.assert_traced_call(
      tracer,
      {Buffer, :handle_cast},
      [{:incoming, ^message}, _opts]
    )
  end

  defp start_transport(server_args \\ []) do
    server_args = Keyword.merge([port: 0, num_acceptors: 1], server_args)
    child_spec = GenSpring.Application.transport_child_spec(server_args)

    server_pid = start_link_supervised!(child_spec)
    {:ok, {_ip, port}} = ThousandIsland.listener_info(server_pid)

    %{port: port, server_pid: server_pid}
  end
end
