defmodule GenSpring.Handler do
  alias GenSpring.Buffer
  alias GenSpring.State
  alias GenSpring.InitError

  @behaviour :sys

  @callback init(buffer :: pid(), state :: State.server_state()) :: {:ok, State.server_state()}

  @callback terminate(reason :: term(), state :: State.server_state()) ::
              no_return()

  @callback handle_request(request :: term(), buffer :: pid(), state :: State.server_state()) ::
              {:noreply, State.server_state()}

  @callback handle_error(error :: term(), buffer :: pid(), state :: State.server_state()) ::
              {:noreply, State.server_state()}

  @callback code_change(old_vsn, state, extra :: term()) ::
              state
            when state: State.server_state(), old_vsn: :undefined | term()

  @optional_callbacks init: 2,
                      terminate: 2,
                      handle_error: 3,
                      code_change: 3

  @doc false
  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour GenSpring.Handler

      @impl GenSpring.Handler
      def handle_error(error, _buffer, state) do
        state
      end

      @impl GenSpring.Handler
      def init(_buffer, _spring), do: {:noreply, %{}}
      @impl GenSpring.Handler
      def code_change(_old_vsn, state, _extra), do: state
      @impl GenSpring.Handler
      def terminate(_reason, _state), do: nil

      defoverridable init: 2, terminate: 2, handle_error: 3, code_change: 3
    end
  end

  # IO.puts(NimbleOptions.docs(@options_schema))

  def start_link(opts) do
    :proc_lib.start_link(__MODULE__, :init, [Keyword.put(opts, :parent, self())])
  end

  def init(opts) do
    case State.initialize(opts) do
      {:ok, spring} ->
        init_ack(spring)

      {:error, {reason, spring}} ->
        init_fail(opts, reason, spring)
    end
    |> loop()
  end

  def shutting_down?(server), do: :sys.get_state(server).shutting_down

  def request(spring, request) do
    wrapped_error(fn ->
      Buffer.request(spring.buffer, request)
    end)
  end

  @doc false
  @impl :sys
  def system_continue(_parent, debug, spring),
    do: State.on_continue(spring, debug) |> loop()

  @doc false
  @impl :sys
  def system_terminate(reason, _parent, _deb, spring),
    do: State.on_terminate(spring, reason)

  @doc false
  @impl :sys
  def system_get_state(spring),
    do: {:ok, spring}

  @doc false
  @impl :sys
  def system_replace_state(state_fun, spring) do
    new_state = state_fun.(spring)

    {:ok, new_state, new_state}
  end

  # FIXME: Review this, see https://github.com/erlang/otp/blob/264738bfb75de9f11defe51753ba5a0599154bd0/lib/stdlib/src/gen_server.erl#L785
  @doc false
  @impl :sys
  def system_code_change(spring, _mod, old_vsn, extra) do
    State.on_code_change(spring, old_vsn, extra)
  catch
    other -> other
  end

  defp wrapped_error(callback) do
    try do
      callback.()
    rescue
      error ->
        send(self(), {:error, error})
    end
  end

  defp loop(spring = %State{}) do
    buffer = spring.buffer
    Buffer.pop_request(buffer)

    receive do
      {:system, from, request} ->
        :sys.handle_system_msg(request, from, buffer, __MODULE__, spring.debug, spring)

      {:stop, reason} ->
        system_terminate({:shutdown, reason}, buffer, spring.debug, spring)

      {:reply, requests} ->
        case request(spring, requests) do
          :ok ->
            spring

          {:error, reason} ->
            send(self(), {:error, reason})

            spring
        end

      {:request, request} ->
        wrapped_error(fn ->
          case spring.module.handle_request(request, buffer, spring.state) do
            {:noreply, state} ->
              Map.put(spring, :state, state)

            {:reply, request, state} ->
              send(self(), {:reply, request})

              Map.put(spring, :state, state)

            {:stop, reason, state} ->
              State.on_stop(spring, reason, state)

            {:error, reason, state} ->
              send(self(), {:error, reason})

              Map.put(spring, :state, state)
          end
        end)

      {:error, reason} ->
        dbg(ERROR: reason)
        State.on_error(spring, reason)

      # TODO: Should we care whence the exit signal came from? Should we inform
      # the server implementation? (e.g. killed by supervisor/buffer/transport
      # close)
      {:EXIT, _from, reason} ->
        system_terminate(reason, buffer, spring.debug, spring)

      msg ->
        # TODO: Implement handle_info callback
        dbg("AAA")
        raise "unexpected message #{inspect(msg)}"
    end
    |> loop()
  end

  defp init_fail(opts, reason, spring) do
    {module, module_opts} = opts[:server]

    exception = InitError.exception(reason, module: module, module_opts: module_opts)

    try do
      module.handle_error(exception, nil, spring)
    rescue
      error ->
        dbg(PQP: error)
    end

    error = {:error, exception}

    :proc_lib.init_fail(opts[:parent], error, error)
  end

  defp init_ack(%State{} = spring) do
    if name = Keyword.get(spring.module_opts, :name),
      do: Process.register(self(), name)

    Process.flag(:trap_exit, true)

    :proc_lib.init_ack(spring.parent, {:ok, self()})

    spring
  end

  @doc false
  @spec child_spec(any()) :: Supervisor.child_spec()
  def child_spec(opts) do
    %{
      id: {__MODULE__, make_ref()},
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      # Never restart
      restart: :temporary
    }
  end
end
