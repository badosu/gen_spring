defmodule GenSpring.ApplicationTest do
  use ExUnit.Case, async: true
  use Mimic

  GenSpring.Requests.Unbridgedclientfrom

  test "" do
    server_module = IntegratedTest
    test_pid = self()

    defmodule server_module do
      use GenSpring

      @impl GenSpring
      def init(_buffer, opts) do
        dbg(opts: opts)
        {:ok, %{initial: :state}}
      end

      @impl GenSpring
      def handle_request(request, buffer, state) do
        dbg(request)

        {:noreply, state}
      end

      @impl GenSpring
      def terminate(reason, state) do
        dbg(hue: state)
        send(state.test_pid, :server_shutdown)
      end
    end

    {pid, port} = start_application(server_module, test_pid: self())

    {:ok, client} = :gen_tcp.connect(:localhost, port, active: false)

    :gen_tcp.send(client, "asdasdsad\n")

    Supervisor.stop(pid)

    assert_receive :server_shutdown, 1000
  end

  defp start_application(server, server_opts \\ []) do
    type = nil

    args = [
      transport: [port: 0, num_acceptors: 1],
      server: {server, server_opts}
    ]

    {:ok, app_pid} =
      start_supervised(%{
        id: GenSpring.Application,
        start: {GenSpring.Application, :start, [type, args]},
        type: :supervisor
      })

    thousand_pid =
      SupervisorHelper.get_child(app_pid, fn
        {{ThousandIsland, _ref}, pid, _type, _modules} -> pid
        _any -> false
      end)

    {:ok, {_ip, port}} = ThousandIsland.listener_info(thousand_pid)

    {app_pid, port}
  end
end
