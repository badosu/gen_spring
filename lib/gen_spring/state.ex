defmodule GenSpring.State do
  @type server_state() :: term()

  @type name() :: atom() | {:global, term()} | {:via, module(), term()}
  @type module_opt() ::
          {:name, name()}
          | Tuple.t(atom(), term())

  # @options_schema NimbleOptions.new!(
  #                   server: [
  #                     type: :mod_arg,
  #                     required: true,
  #                     doc:
  #                       "A `{module, args}` tuple, where `module` implements GenSpring behaviour."
  #                   ],
  #                   parent: [
  #                     type: :pid,
  #                     required: true,
  #                     doc: "The process which spawned the instance."
  #                   ],
  #                   buffer: [
  #                     type: :pid,
  #                     required: true,
  #                     doc: "The buffer process associated to the instance."
  #                   ],
  #                   server_opts: [
  #                     type: :keyword_list,
  #                     default: [],
  #                     keys: [
  #                       debug: [type: :keyword_list]
  #                     ]
  #                   ]
  #                 )

  use TypedStruct

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

  def initialize(opts) do
    spring = initialize_state(opts)

    try do
      spring.module.init(spring.buffer, spring.module_opts)
    rescue
      error ->
        {:error, error}
    end
    |> case do
      {:noreply, state} ->
        {:ok, Map.put(spring, :state, state)}

      {:reply, requests, state} ->
        send(self(), {:reply, requests})

        {:ok, Map.put(spring, :state, state)}

      {:error, reason} ->
        {:error, {reason, spring}}

      # {:stop, reason} ->
      #   {:ok, on_stop(spring, reason, spring.state)}
      #
      # {:stop, reply, reason} ->
      #   {:ok, on_stop(spring, reason, spring.state)}

      invalid_init_value ->
        {:error, {{:invalid_init_value, invalid_init_value}, spring}}
    end
  end

  def on_code_change(%__MODULE__{} = spring, old_vsn, extra) do
    with {:ok, new_state} <- apply(spring.module, :code_change, [old_vsn, spring.state, extra]) do
      {:ok, Map.put(spring, :state, new_state)}
    end
  end

  def on_error(%__MODULE__{} = spring, error) do
    case spring.module.handle_error(error, spring.buffer, spring.state) do
      {:noreply, state} ->
        Map.put(spring, :state, state)

      {:stop, reason, state} ->
        on_stop(spring, reason, state)
    end
  end

  def on_terminate(%__MODULE__{} = spring, reason) do
    try do
      spring.module.terminate(reason, spring)
    rescue
      error ->
        dbg(error)
    end

    exit(reason)
  end

  def on_continue(%__MODULE__{} = spring, debug) do
    Map.put(spring, :debug, debug)
  end

  def on_stop(%__MODULE__{} = spring, reason, state) do
    send(self(), {:stop, reason})

    Map.put(spring, :state, state)
  end

  defp initialize_state(opts) do
    {module, module_opts} = opts[:server]
    buffer = opts[:buffer]
    debug = opts |> Keyword.get(:debug, []) |> :sys.debug_options()

    %__MODULE__{
      parent: opts[:parent],
      module: module,
      module_opts: module_opts,
      buffer: buffer,
      debug: debug,
      state: nil,
      shutting_down: false
    }
  end
end
