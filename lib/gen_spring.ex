defmodule GenSpring.InitError do
  defexception [:message, :reason, :module_opts, :module]

  @impl true
  def message(opts) do
    module_name = opts |> Keyword.fetch!(:module) |> Macro.to_string()

    fields =
      opts
      |> Keyword.take([:reason, :module_opts, :module])
      |> Map.put(
        :message,
        "GenSpring server #{module_name} failed to initialize"
      )

    struct!(__MODULE__, fields)
  end
end

defmodule GenSpring do
  alias GenSpring.Buffer

  use TypedStruct

  @type server_state() :: term()

  typedstruct do
    field(:mod, module(), required: true)
    field(:mod_opts, any(), required: true)
    field(:state, server_state(), required: true)
    field(:buffer, Buffer.t(), required: true)
  end

  @callback init(spring :: __MODULE__.t()) :: {:ok, __MODULE__.t()}

  @callback handle_request(request :: term(), spring) ::
              {:noreply, spring}
            when spring: GenSpring.t()

  @callback handle_error(error :: term(), spring) ::
              {:noreply, spring}
            when spring: GenSpring.t()

  @callback handle_shutdown(reason :: term(), spring) ::
              no_return()
            when spring: GenSpring.t()

  @callback code_change(old_vsn, state, extra :: term()) ::
              state
            when state: server_state(), old_vsn: :undefined | term()

  def init(spring), do: {:ok, Map.put(spring, :state, %{})}
  def code_change(_old_vsn, state, _extra), do: state
  def handle_error(_error, spring), do: spring
  def handle_close(spring), do: spring
  def handle_shutdown(_reason, _spring), do: nil

  defoverridable init: 1, handle_error: 2, handle_close: 1, code_change: 3

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
  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour GenSpring
    end
  end

  def start_link(opts),
    do: :proc_lib.start_link(__MODULE__, :init, [opts])

  def child_spec(opts),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }

  def init(opts) do
    NimbleOptions.validate!(opts, @options_schema)

    {module, module_args} = opts[:module]
    buffer = opts[:buffer]
    me = self()

    %__MODULE__{mod: module, mod_opts: module_args, state: nil, buffer: buffer}
    |> init_it()
    |> case do
      {:ok, spring = %__MODULE__{}} ->
        if opts[:name], do: Process.register(me, opts[:name])

        :ok = :proc_lib.init_ack(buffer, {:ok, me})

        deb = :sys.debug_options([])

        loop(buffer, deb, spring)

      {:ok, bad_return_value} ->
        error = {:bad_return_value, bad_return_value}
        :ok = :proc_lib.init_ack(buffer, error)
        exit(error)

      {:stop, reason} ->
        :proc_lib.init_fail(buffer, reason)

      bad_return_value ->
        error = {:bad_return_value, bad_return_value}
        :proc_lib.init_fail(buffer, error)
    end
  end

  defp init_it(spring) do
    try do
      spring.module.init(spring)
    catch
      error -> {:error, error}
    end
  end

  def request(spring, request), do: Buffer.request(spring.buffer, request)

  @doc false
  def system_continue(buffer, deb, spring), do: loop(buffer, deb, spring)

  @doc false
  def system_terminate(reason, _parent, _deb, spring) do
    do_shutdown(reason, spring)
  end

  defp do_shutdown(reason, spring) do
    if not match?({:closed, _}, reason) do
      Buffer.stop(spring.buffer, reason)
    end

    spring.mod.handle_shutdown(reason, spring)

    exit(reason)
  end

  @doc false
  def system_get_state(spring), do: {:ok, spring}

  @doc false
  def system_replace_state(state_fun, spring) do
    new_state = state_fun.(spring)

    {:ok, new_state, new_state}
  end

  @doc false
  # FIXME: Review this, doesn't seem right, see https://github.com/erlang/otp/blob/264738bfb75de9f11defe51753ba5a0599154bd0/lib/stdlib/src/gen_server.erl#L785
  def system_code_change(spring, _mod, old_vsn, extra) do
    with {:ok, new_state} <- apply(spring.mod, :code_change, [old_vsn, spring.state, extra]) do
      {:ok, Map.put(spring, :state, new_state)}
    end
  catch
    other -> other
  end

  defp loop(buffer, deb, spring) do
    Buffer.pop_request(buffer)

    state =
      receive do
        {:system, from, request} ->
          :sys.handle_system_msg(request, from, buffer, __MODULE__, deb, spring)

          spring.state

        {:request, request} ->
          case spring.mod.handle_request(request, spring.state) do
            {:noreply, state} ->
              state

            {:close, reason} ->
              Buffer
          end

        {:error, error} ->
          case spring.mod.handle_error(error, spring.state) do
            {:noreply, state} ->
              state
          end
      end

    loop(buffer, deb, Map.put(spring, :state, state))
  end

  defp write_debug(device, event, name) do
    IO.write(device, "#{inspect(name)} event = #{inspect(event)}\n")
  end
end
