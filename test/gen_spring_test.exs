defmodule GenSpringTest do
  use ExUnit.Case, async: true

  describe "OTP" do
    test "implements the :sys behavior" do
      server_module = ImplementsSysBehavior

      defmodule server_module do
        use GenSpring

        @impl GenSpring
        def init(_buffer, _opts), do: {:ok, %{initial: :state}}

        @impl GenSpring
        def handle_request(_request, _buffer, state), do: {:noreply, state}

        @impl GenSpring
        def terminate(reason, state), do: send(state.buffer, {:did_shut_down, reason})
      end

      server = start_supervised!({GenSpring, buffer: self(), server: {server_module, []}})

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
      server_module = TerminatesProperlyOnExit

      defmodule server_module do
        use GenSpring

        @impl GenSpring
        def handle_request(_request, _buffer, state), do: {:noreply, state}

        @impl GenSpring
        def terminate(reason, state), do: send(state.buffer, {:did_shut_down, reason})
      end

      server = start_supervised!({GenSpring, buffer: self(), server: {server_module, []}})

      Process.exit(server, :some_reason)

      assert_receive {:did_shut_down, :some_reason}
    end
  end

  describe "initialization" do
    test "providing module not implementing GenSpring errors out" do
      server_module = NoImplementGenSpring

      defmodule server_module do
      end

      module_opts = []

      init_error =
        GenSpring.InitError.exception(:no_genspring,
          module: server_module,
          module_opts: module_opts
        )

      start_result =
        start_supervised({GenSpring, buffer: self(), server: {server_module, module_opts}})

      assert match?({:error, {^init_error, _child}}, start_result)
    end

    test "returning {:error, error} on callback init does not spawn the server" do
      server_module = InitErrorShutsDown

      defmodule server_module do
        use GenSpring

        @impl GenSpring
        def init(_buffer, _opts), do: {:error, :woops}

        @impl GenSpring
        def handle_request(request, _buffer, %{requests: requests} = state) do
          {:noreply, Map.put(state, :requests, requests ++ [request.name])}
        end

        @impl GenSpring
        def terminate(reason, state), do: send(state.buffer, {:did_shut_down, reason})
      end

      module_opts = []

      init_error =
        GenSpring.InitError.exception(:woops,
          module: server_module,
          module_opts: module_opts
        )

      start_result =
        start_supervised({GenSpring, buffer: self(), server: {server_module, module_opts}})

      assert match?({:error, {^init_error, _child}}, start_result)

      refute_receive {:did_shut_down, _}
    end
  end

  describe "" do
    test "" do
      server_module = ReceivesRequests

      defmodule server_module do
        @impl GenSpring

        def init(_buffer, _opts), do: {:ok, %{requests: []}}

        @impl GenSpring
        def handle_request(request, _buffer, %{requests: requests} = state) do
          {:noreply, Map.put(state, :requests, requests ++ [request.name])}
        end
      end

      {:ok, server} = GenSpring.start_link(buffer: self(), server: {server_module, []})

      assert_receive {:"$gen_cast", :pop_request}
      refute_receive _

      send(server, {:request, %{name: :req1}})

      assert match?(%{state: %{requests: [:req1]}}, :sys.get_state(server))
    end
  end
end
