defmodule GenSpring.InitError do
  defexception [:reason, :module_opts, :module]

  @impl Exception
  def message(init_error),
    do: "GenSpring server #{inspect(init_error.module)} failed to initialize"

  def exception(spring, reason) do
    fields =
      spring
      |> Map.take([:module, :module_opts])
      |> Map.put(:reason, reason)

    struct!(__MODULE__, fields)
  end
end

defmodule GenSpring do
  alias GenSpring.Buffer
  alias GenSpring.InitError

  @behaviour :sys

  use TypedStruct

  @type server_state() :: term()

  typedstruct do
    field(:module, module(), required: true)
    field(:module_opts, Keyword.t(), required: true)
    field(:state, server_state(), required: true)
    field(:dbg_opt, List.t(:sys.dbg_opt()), required: true)
    field(:buffer, pid() | :closed, required: true)
    field(:shutting_down, bool(), required: true)
  end

  @callback init(buffer :: pid(), state :: server_state()) :: {:ok, server_state()}

  @callback handle_error(error :: term(), buffer :: pid(), state :: server_state()) ::
              {:noreply, server_state()}

  @callback terminate(reason :: term(), state :: server_state()) ::
              no_return()

  @callback code_change(old_vsn, state, extra :: term()) ::
              state
            when state: server_state(), old_vsn: :undefined | term()

  @callback handle_request(request :: term(), buffer :: pid(), state :: server_state()) ::
              {:noreply, server_state()}

  @optional_callbacks init: 2,
                      terminate: 2,
                      handle_error: 3,
                      code_change: 3

  @doc false
  def gen_spring_impl() do
    quote do
      @impl GenSpring
      def handle_error(_error, _buffer, state), do: state
      @impl GenSpring
      def init(_buffer, _spring), do: {:ok, %{}}
      @impl GenSpring
      def code_change(_old_vsn, state, _extra), do: state
      @impl GenSpring
      def terminate(_reason, _state), do: nil

      defoverridable init: 2, terminate: 2, handle_error: 3, code_change: 3
    end
  end

  @doc false
  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour GenSpring

      unquote(gen_spring_impl())
    end
  end

  @options_schema NimbleOptions.new!(
                    module: [
                      type: :mod_arg,
                      required: true,
                      doc:
                        "A `{module, args}` tuple, where `module` instantiates and sends messages to `GenSpring.Communication.Buffer`."
                    ],
                    buffer: [
                      type: :pid,
                      required: true,
                      doc: "The buffer process associated to the instance."
                    ],
                    name: [
                      type: :any,
                      doc:
                        "Used for name registration as described in the \"Name registration\" section in the documentation for `GenServer`."
                    ]
                  )

  def start_link(opts),
    do: :proc_lib.start_link(__MODULE__, :init, [opts])

  def spawn(opts),
    do: :proc_lib.spawn(__MODULE__, :init, [opts])

  def child_spec(opts),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }

  def new(opts) do
    {module, module_args} = opts[:module]
    buffer = opts[:buffer]

    %__MODULE__{
      module: module,
      module_opts: module_args,
      state: nil,
      buffer: buffer,
      shutting_down: false,
      dbg_opt: :sys.debug_options([])
    }
  end

  def init(opts) do
    NimbleOptions.validate!(opts, @options_schema)

    buffer = opts[:buffer]
    me = self()
    spring = new(opts)

    spring =
      case do_init(spring) do
        {:ok, state} ->
          if opts[:name], do: Process.register(me, opts[:name])

          :proc_lib.init_ack(buffer, {:ok, me})

          Map.put(spring, :state, state)

        {:stop, reason} ->
          # NOTE: When the server is stopped we allow it to start so that the
          # reason is handled on `terminate`
          :proc_lib.init_ack(buffer, {:ok, me})

          shutdown(spring, {:server_stopped, reason})

        {:error, error} ->
          init_fail(spring, {:error, error})

        bad_return_value ->
          init_fail(spring, {:bad_return_value, bad_return_value})
      end

    loop(spring)
  end

  def shutting_down?(server), do: :sys.get_state(server).shutting_down

  def request(spring, request), do: Buffer.request(spring.buffer, request)

  @doc false
  @impl :sys
  def system_continue(_parent, dbg_opt, spring),
    do: spring |> Map.put(:dbg_opt, dbg_opt) |> loop()

  @doc false
  @impl :sys
  def system_terminate(reason, _parent, _deb, spring) do
    do_system_terminate(reason, spring)
  end

  @doc false
  @impl :sys
  def system_get_state(spring), do: {:ok, spring}

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
    with {:ok, new_state} <- apply(spring.mod, :code_change, [old_vsn, spring.state, extra]) do
      {:ok, Map.put(spring, :state, new_state)}
    end
  catch
    other -> other
  end

  defp loop(spring = %__MODULE__{}) do
    buffer = spring.buffer
    Buffer.pop_request(buffer)

    receive do
      {:system, from, request} ->
        :sys.handle_system_msg(request, from, buffer, __MODULE__, spring.dbg_opt, spring)

      {:request, request}
      when not spring.shutting_down ->
        case spring.module.handle_request(request, buffer, spring.state) do
          {:noreply, state} ->
            Map.put(spring, :state, state)

          {:reply, request, state} ->
            with {:error, error} <- Buffer.request(buffer, request) do
              send(self(), {:error, error})
            end

            Map.put(spring, :state, state)

          {:stop, reason, spring} ->
            shutdown(spring, {:server_stopped, reason})

          {:error, reason, state} ->
            send(self(), {:error, reason})

            Map.put(spring, :state, state)
        end

      {:error, error}
      when not spring.shutting_down ->
        case spring.module.handle_error(error, buffer, spring.state) do
          {:noreply, state} ->
            Map.put(spring, :state, state)

          {:stop, reason} ->
            shutdown(spring, {:server_stopped, reason})
        end
    end
    |> loop()
  end

  def shutdown(server, reason) do
    send(server, {:shutdown, reason})
  end

  defp do_system_terminate(reason, spring) do
    spring.module.terminate(reason, spring)

    exit(reason)
  end

  defp do_init(spring) do
    try do
      spring.module.init(spring.buffer, spring.module_opts)
    catch
      error -> {:error, error}
    end
  end

  defp init_fail(spring = %__MODULE__{}, reason) do
    exception = InitError.exception(spring, reason)
    error = {:error, exception}

    :proc_lib.init_fail(spring.buffer, error, error)
  end
end
