defmodule GenSpring.ApplicationTest do
  use ExUnit.Case, async: true
  use Mimic

  import Test.Support.GenSpring

  test "" do
    server_module = test_server_module(IntegratedTest)

    defserver server_module, self() do
      @impl GenSpring
      def handle_request(request, buffer, state) do
        dbg(request)

        {:noreply, state}
      end

      @impl GenSpring
      def terminate(reason, state) do
        dbg(@test_pid)
        send(@test_pid, :server_shutdown)
      end
    end

    {pid, port} = start_application(server_module)

    {:ok, client} = :gen_tcp.connect(:localhost, port, active: false)

    :gen_tcp.send(client, "asdasdsad\n")

    Supervisor.stop(pid)

    assert_receive :server_shutdown, 1000
  end

  defp start_application(server) do
    type = nil

    args = [
      transport: [port: 0, num_acceptors: 1],
      server: {server, []}
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
