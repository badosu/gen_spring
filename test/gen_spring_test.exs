defmodule GenSpringTest do
  use ExUnit.Case, async: true

  def test_server_module(module) do
    Module.concat([__MODULE__, SpringTestServer, module])
  end

  defmacro defserver(module, do: expression) do
    quote do
      defmodule unquote(module) do
        use GenSpring

        unquote(expression)
      end
    end
  end

  describe "OTP" do
    test "implements the :sys behavior" do
      server_module = test_server_module(SysBehavior)

      defserver(server_module) do
        @impl GenSpring
        def init(_buffer, _opts), do: {:ok, dbg(%{initial: :state})}

        @impl GenSpring
        def handle_request(_request, _buffer, state), do: {:noreply, state}

        @impl GenSpring
        def terminate(reason, state) do
          send(state.buffer, {:did_shut_down, reason})
        end
      end

      server = start_supervised!({GenSpring, buffer: self(), module: {server_module, []}})

      assert :ok == :sys.suspend(server)
      assert :ok == :sys.resume(server)

      assert match?(
               %{module: ^server_module, state: %{initial: :state}},
               :sys.get_state(server)
             )

      replaced_state =
        :sys.replace_state(server, fn spring -> put_in(spring.state, %{new: :state}) end)

      assert match?(%{state: %{new: :state}}, replaced_state)
      assert match?(^replaced_state, :sys.get_state(server))

      :sys.terminate(server, :some_reason)

      assert_receive {:did_shut_down, :some_reason}
    end

    test "properly terminates on exit" do
      {:ok, server} = GenSpring.start_link(buffer: self(), module: {TestSpringServer, []})

      Process.flag(:trap_exit, true)
      Process.exit(server, :some_reason)

      assert_receive {:did_shut_down, :some_reason}
    end
  end

  describe "callback init/2" do
    test "returning {:error, error} shuts down" do
      defmodule TestSpringServer do
        use GenSpring

        @impl GenSpring
        def init(_buffer, _opts) do
          {:error, :woops}
        end

        @impl GenSpring
        def handle_request(request, _buffer, %{requests: requests} = state) do
          {:noreply, Map.put(state, :requests, requests ++ [request.name])}
        end

        @impl GenSpring
        def terminate(reason, state) do
          dbg({reason, state})
        end
      end

      assert match?(
               {:error,
                %GenSpring.InitError{
                  reason: {:error, :woops},
                  module_opts: [],
                  module: TestSpringServer
                }},
               GenSpring.start_link(buffer: self(), module: {TestSpringServer, []})
             )
    end
  end

  describe "" do
    defmodule TestSpringServer do
      use GenSpring

      @impl GenSpring
      def init(_buffer, _opts) do
        {:ok, %{requests: []}}
      end

      @impl GenSpring
      def handle_request(request, _buffer, %{requests: requests} = state) do
        {:noreply, Map.put(state, :requests, requests ++ [request.name])}
      end
    end

    test "" do
      {:ok, server} = GenSpring.start_link(buffer: self(), module: {TestSpringServer, []})

      assert_receive {:"$gen_cast", :pop_request}
      refute_receive _

      send(server, {:request, %{name: :req1}})

      assert match?(
               %{state: %{requests: [:req1]}},
               :sys.get_state(server)
             )
    end
  end
end
