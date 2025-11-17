defmodule GenSpring do
  alias GenSpring.Buffer
  alias GenSpring.InitError

  @behaviour :sys

  @type server_state() :: term()

  use TypedStruct

  @type name() :: atom() | {:global, term()} | {:via, module(), term()}
  @type module_opt() ::
          {:name, name()}
          | Tuple.t(atom(), term())

  typedstruct do
    @typedoc """
    """

    field(:module, module(), required: true)
    field(:module_opts, [module_opt], required: true)
    field(:state, server_state(), required: true)
    field(:debug, List.t(:sys.dbg_opt()), required: true)
    field(:buffer, pid() | :closed, required: true)
    field(:parent, pid(), required: true)
    field(:shutting_down, bool(), required: true)
  end

  @callback init(buffer :: pid(), state :: server_state()) :: {:ok, server_state()}

  @callback terminate(reason :: term(), state :: server_state()) ::
              no_return()

  @callback handle_request(request :: term(), buffer :: pid(), state :: server_state()) ::
              {:noreply, server_state()}

  @callback handle_error(error :: term(), buffer :: pid(), state :: server_state()) ::
              {:noreply, server_state()}

  @callback code_change(old_vsn, state, extra :: term()) ::
              state
            when state: server_state(), old_vsn: :undefined | term()

  @optional_callbacks init: 2,
                      terminate: 2,
                      handle_error: 3,
                      code_change: 3

  @doc false
  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour GenSpring

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

  @options_schema NimbleOptions.new!(
                    server: [
                      type: :mod_arg,
                      required: true,
                      doc:
                        "A `{module, args}` tuple, where `module` implements GenSpring behaviour."
                    ],
                    parent: [
                      type: :pid,
                      required: true,
                      doc: "The process which spawned the instance."
                    ],
                    buffer: [
                      type: :pid,
                      required: true,
                      doc: "The buffer process associated to the instance."
                    ],
                    server_opts: [
                      type: :keyword_list,
                      default: [],
                      keys: [
                        debug: [type: :keyword_list]
                      ]
                    ]
                  )

  IO.puts("DOCS!!\n\n")
  IO.puts(NimbleOptions.docs(@options_schema))
  IO.puts("\n\nDOCS!!")

  def start_link(opts),
    do: :proc_lib.start_link(__MODULE__, :init, [Keyword.put(opts, :parent, self())])

  def child_spec(opts),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }

  defp init_new(opts) do
    {module, module_opts} = opts[:server]
    buffer = opts[:buffer]
    debug = opts |> Keyword.get(:debug, []) |> :sys.debug_options()

    module.__info__(:attributes)
    |> Keyword.get(:behaviour, [])
    |> Enum.member?(GenSpring)
    |> if do
      spring = %__MODULE__{
        parent: opts[:parent],
        module: module,
        module_opts: module_opts,
        buffer: buffer,
        debug: debug,
        state: nil,
        shutting_down: false
      }

      spring
    else
      init_fail(opts, :no_genspring)
    end
  end

  def init(opts) do
    NimbleOptions.validate!(opts, @options_schema)

    spring = init_new(opts)

    case init_module(spring) do
      {:ok, state} ->
        init_ack(spring)

        Map.put(spring, :state, state)

      {:stop, reason} ->
        init_ack(spring)

        stop(spring, reason, spring.state)

      {:error, reason} ->
        init_fail(opts, reason)

      bad_return_value ->
        init_fail(opts, {:bad_return_value, bad_return_value})
    end
    |> loop()
  end

  def shutting_down?(server), do: :sys.get_state(server).shutting_down

  def request(spring, request), do: Buffer.request(spring.buffer, request)

  @doc false
  @impl :sys
  def system_continue(_parent, debug, spring),
    do: spring |> Map.put(:debug, debug) |> loop()

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
        :sys.handle_system_msg(request, from, buffer, __MODULE__, spring.debug, spring)

      {:stop, reason} ->
        dbg(reason: reason)
        system_terminate({:server_stopped, reason}, spring.buffer, spring.debug, spring)

      {:request, request} ->
        case spring.module.handle_request(request, buffer, spring.state) do
          {:noreply, state} ->
            Map.put(spring, :state, state)

          {:reply, request, state} ->
            with {:error, error} <- Buffer.request(buffer, request) do
              send(self(), {:error, error})
            end

            Map.put(spring, :state, state)

          {:stop, reason, state} ->
            stop(spring, reason, state)

          {:error, error, state} ->
            send(self(), {:error, error})

            Map.put(spring, :state, state)
        end

      {:error, error} ->
        case spring.module.handle_error(error, buffer, spring.state) do
          {:noreply, state} ->
            Map.put(spring, :state, state)

          {:stop, reason, state} ->
            stop(spring, reason, state)
        end

      # TODO: Should we care whence the exit signal came from? Should we inform
      # the server implementation? (e.g. killed by supervisor/buffer/transport
      # close)
      {:EXIT, _from, reason} ->
        dbg(reason: reason)
        system_terminate(reason, buffer, spring.debug, spring)
    end
    |> loop()
  end

  defp stop(spring, reason, state) do
    send(self(), {:stop, reason})

    Map.put(spring, :state, state)
  end

  defp do_system_terminate(reason, spring) do
    spring.module.terminate(reason, spring)

    dbg({:terminn, reason})

    exit(reason)
  end

  defp init_module(spring) do
    try do
      spring.module.init(spring.buffer, spring.module_opts)
    catch
      error -> {:error, error}
    end
  end

  defp init_fail(opts, reason) do
    {module, module_opts} = opts[:server]

    exception = InitError.exception(reason, module: module, module_opts: module_opts)
    error = {:error, exception}

    :proc_lib.init_fail(opts[:parent], error, error)
  end

  defp init_ack(spring = %__MODULE__{}) do
    if name = Keyword.get(spring.module_opts, :name),
      do: Process.register(self(), name)

    Process.flag(:trap_exit, true)

    :proc_lib.init_ack(spring.parent, {:ok, self()})
  end
end
