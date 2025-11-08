defmodule GenSpring do
  alias GenSpring.Buffer

  @options_schema NimbleOptions.new!(
                    module: [
                      type: :pid,
                      doc:
                        "A `{module, args}` tuple, where `module` instantiates and sends messages to `GenSpring.Communication.Buffer`."
                    ],
                    name: [
                      type: :any,
                      doc:
                        "Used for name registration as described in the \"Name registration\" section in the documentation for `GenServer`."
                    ]
                  )

  def init(opts) do
    {module, module_args} = opts[:module]
    buffer = opts[:buffer]
    me = self()

    case module.init(module_args) do
      {:ok, %{}} ->
        if opts[:name], do: Process.register(self(), opts[:name])

        :proc_lib.init_ack(buffer, {:ok, me})

        loop(buffer, %{mod: module})
    end
  end

  defp loop(buffer, state) do
    state =
      receive do
        {:request, request} ->
          case state.mod.handle_request(request, state) do
            {:noreply, state} ->
              state
          end

        {:error, error} ->
          case state.mod.handle_error(error, state) do
            {:noreply, state} ->
              state
          end
      end

    Buffer.pop_request(buffer)

    loop(buffer, state)
  end
end
