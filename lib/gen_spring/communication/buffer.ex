defmodule GenSpring.Communication.Buffer do
  use GenServer

  @options_schema NimbleOptions.new!(
                    transport: [
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
  def start_link(opts) do
    opts = NimbleOptions.validate!(opts, @options_schema)
    GenServer.start_link(__MODULE__, opts, Keyword.take(opts, [:name]))
  end

  def connect(transport, _state) do
    DynamicSupervisor.start_child(
      GenSpring.BufferSupervisor,
      {__MODULE__, name: MyBuffer, transport: transport}
    )
  end

  def incoming(server, message) do
    GenServer.cast(server, {:incoming, message})
  end

  @impl GenServer
  def init(opts) do
    transport = Keyword.fetch!(opts, :transport)
    {:ok, %{transport: transport}}
  end

  @impl GenServer
  def handle_cast({:incoming, message}, state) do
    {:ok, request} = GenSpring.Requests.parse_incoming(message)
    {:noreply, state}
  end
end
