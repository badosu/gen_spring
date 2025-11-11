defmodule GenSpring do
  alias GenSpring.Buffer

  use TypedStruct

  typedstruct do
    field(:mod, module(), required: true)
    field(:server_state, any(), required: true)
    field(:buffer, any(), required: true)
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
                      doc:
                        "Used for name registration as described in the \"Name registration\" section in the documentation for `GenServer`."
                    ],
                    name: [
                      type: :any,
                      doc:
                        "Used for name registration as described in the \"Name registration\" section in the documentation for `GenServer`."
                    ]
                  )

  def start_link(opts) do
    NimbleOptions.validate!(opts, @options_schema)

    :proc_lib.start_link(__MODULE__, :init, [opts])
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def init(opts) do
    {module, module_args} = opts[:module]
    buffer = opts[:buffer]
    me = self()

    case module.init(module_args) do
      {:ok, server_state} ->
        if opts[:name], do: Process.register(me, opts[:name])

        :proc_lib.init_ack(buffer, {:ok, me})

        deb = :sys.debug_options([])

        loop(buffer, deb, %{mod: module, server_state: server_state})
    end
  end

  @doc false
  def system_continue(buffer, deb, state), do: loop(buffer, deb, state)

  @doc false
  def system_terminate(reason, _parent, _deb, _chs), do: exit(reason)

  @doc false
  def system_get_state(state), do: {:ok, state}

  @doc false
  def system_replace_state(state_fun, state) do
    new_state = state_fun.(state)

    {:ok, new_state, new_state}
  end

  defp loop(buffer, deb, state) do
    server_state =
      receive do
        {:system, from, request} ->
          :sys.handle_system_msg(request, from, buffer, __MODULE__, deb, state)

        {:request, request} ->
          case state.mod.handle_request(request, state.server_state) do
            {:noreply, server_state} ->
              server_state
          end

        {:error, error} ->
          case state.mod.handle_error(error, state.server_state) do
            {:noreply, server_state} ->
              server_state
          end
      end

    Buffer.pop_request(buffer)

    loop(buffer, deb, Map.put(state, :server_state, server_state))
  end
end
