defmodule GenSpring.Communication.Buffer do
  use GenServer

  def connect(socket, _state) do
    DynamicSupervisor.start_child(
      GenSpring.BufferSupervisor,
      {__MODULE__, name: MyBuffer, transport: socket}
    )
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, Keyword.take(opts, [:name]))
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
    # dbg({:incoming, message})
    {:noreply, state}
  end
end
