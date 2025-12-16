defmodule GenSpring.ServerTest do
  use ExUnit.Case, async: true
  use Mimic

  defmodule InitFailServer do
    alias GenSpring.Protocol.Requests

    use GenSpring.Handler

    @impl GenSpring.Handler
    def init(_buffer, opts) do
      raise "#{opts[:init_error_msg]}"
    end

    @impl GenSpring.Handler
    def handle_error(%GenSpring.InitError{reason: reason}, _buffer, spring) do
      send(spring.module_opts[:test_pid], {:init_error, reason})
    end

    @impl GenSpring.Handler
    def handle_request(request, _buffer, state) do
      send(state.test_pid, {:unexpected_request, request})

      {:noreply, state}
    end
  end

  defmodule IntegratedTest do
    alias GenSpring.Protocol.Requests

    use GenSpring.Handler

    @impl GenSpring.Handler
    def init(_buffer, opts) do
      {welcome, opts} = Keyword.pop!(opts, :welcome)
      state = Map.new(opts)

      send(state.test_pid, {:server_init, state})

      {:reply, welcome, state}
    end

    @impl GenSpring.Handler
    def handle_request(%Requests.PING{}, _buffer, state) do
      {:reply, %Requests.PONG{}, state}
    end

    @impl GenSpring.Handler
    def handle_request(request, _buffer, state) do
      send(state.test_pid, {:unexpected_request, request})

      {:noreply, state}
    end

    @impl GenSpring.Handler
    def handle_error(reason, _buffer, spring) do
      send(spring.state.test_pid, {:unexpected_error, reason})

      {:noreply, spring.state}
    end

    @impl GenSpring.Handler
    def terminate(reason, %GenSpring.State{state: state}) do
      send(state.test_pid, {:server_shutdown, reason})
    end
  end

  test "looks normal" do
    welcome_msg = "TASSERVER 0.38 2025.04.11 8201 0"

    assert {:ok, welcome_reply} = GenSpring.Protocol.Requests.decode(welcome_msg)

    {_pid, port} =
      start_server(IntegratedTest,
        test_pid: self(),
        welcome: welcome_reply
      )

    assert {:ok, client} = :gen_tcp.connect(:localhost, port, mode: :binary, active: false)

    assert_receive {:server_init, _state}

    assert_recv(client, welcome_msg)

    assert :ok = :gen_tcp.send(client, "PI")

    assert :ok = :gen_tcp.send(client, "NG")

    assert :ok = :gen_tcp.send(client, "\n")

    assert_recv(client, "PONG")

    assert :ok = :gen_tcp.close(client)

    assert_receive {:server_shutdown, {:shutdown, :transport_closed}}

    refute_received {:unexpected_request, _request}
    refute_received {:unexpected_error, _error}
  end

  test "error on init()" do
    init_error_msg = "this server not gud"

    {_pid, port} =
      start_server(InitFailServer,
        init_error_msg: init_error_msg,
        test_pid: self()
      )

    assert {:ok, client} = :gen_tcp.connect(:localhost, port, mode: :binary, active: false)

    on_exit(fn ->
      :gen_tcp.close(client)
    end)

    assert_receive {:init_error, %RuntimeError{message: ^init_error_msg}}
    refute_received {:server_init, _request}
    refute_received {:unexpected_request, _request}
    refute_received {:unexpected_error, _error}
  end

  # defp assert_send(client, message) do
  #   assert :ok = :gen_tcp.send(client, "#{message}\n")
  #   refute_receive {:unexpected_error, _reason}
  # end

  defp assert_recv(client, message) do
    assert {:ok, "#{message}\n"} == :gen_tcp.recv(client, 0, 100)
  end

  defp start_server(server, opts) do
    opts = Keyword.put(opts, :supervisor, :"#{server}TestSupervisor")
    opts = [transport: [port: 0, num_acceptors: 1], server: {server, opts}]
    server_pid = start_supervised!({GenSpring.Server, opts})

    thousand_pid =
      SupervisorHelper.get_child(server_pid, fn
        {{ThousandIsland, _ref}, pid, _type, _modules} -> pid
        _any -> false
      end)

    assert {:ok, {_ip, port}} = ThousandIsland.listener_info(thousand_pid)

    {server_pid, port}
  end
end
