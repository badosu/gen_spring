defmodule GenSpringTest do
  use ExUnit.Case, async: true

  describe "OTP" do
    defmodule TestSpringServer1 do
      use GenSpring

      @impl GenSpring
      def init(_buffer, _opts), do: {:ok, %{initial: :state}}

      @impl true
      def handle_request(_request, _buffer, state), do: {:noreply, state}

      @impl true
      def terminate(reason, state) do
        send(state.buffer, {:did_shut_down, reason})
      end
    end

    test "implements the :sys behavior" do
      {:ok, server} = GenSpring.start_link(buffer: self(), module: {TestSpringServer1, []})

      assert :ok == :sys.suspend(server)
      assert :ok == :sys.resume(server)

      assert match?(
               %{module: TestSpringServer1, state: %{initial: :state}},
               :sys.get_state(server)
             )

      replaced_state =
        :sys.replace_state(server, fn spring -> put_in(spring.state, %{new: :state}) end)

      assert match?(%{state: %{new: :state}}, replaced_state)
      assert match?(^replaced_state, :sys.get_state(server))

      Process.flag(:trap_exit, true)
      Process.exit(server, :some_reason)

      assert_receive {:did_shut_down, :some_reason}, 100
    end
  end

  describe "callback init/2" do
    defmodule TestSpringServer3 do
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

    test "returning {:error, error} shuts down" do
      assert match?(
               {:error,
                %GenSpring.InitError{
                  reason: {:error, :woops},
                  module_opts: [],
                  module: TestSpringServer3
                }},
               GenSpring.start_link(buffer: self(), module: {TestSpringServer3, []})
             )
    end
  end

  describe "" do
    defmodule TestSpringServer2 do
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
      {:ok, server} = GenSpring.start_link(buffer: self(), module: {TestSpringServer2, []})

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
