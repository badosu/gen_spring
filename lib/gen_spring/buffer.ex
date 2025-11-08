defmodule GenSpring.Buffer do
  use GenServer
  use TypedStruct

  alias GenSpring.Requests.ParseError
  alias ThousandIsland.Socket
  alias GenSpring.Requests

  defmodule TransportError do
    defexception [:message, :transport_error]

    @impl Exception
    def exception(error) do
      message = "Failed to communicate with transport"

      %__MODULE__{message: message, transport_error: error}
    end
  end

  @type request_result() :: {:ok, Request.t()} | {:error, ParseError.t()}
  @type messages() :: {List.t(String.t()), List.t(String.t())}
  @type requests() :: {List.t(request_result()), List.t(request_result())}

  typedstruct do
    field(:messages, messages(), enforce: true)
    field(:requests, requests(), enforce: true)
    field(:awaiting_server, boolean(), enforce: true)
    field(:server, pid(), enforce: true)
    field(:transport, pid(), enforce: true)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, Keyword.take(opts, [:name]))
  end

  def push_messages(buffer_pid, messages) do
    GenServer.cast(buffer_pid, {:push_messages, messages})
  end

  def pop_request(buffer_pid) do
    GenServer.cast(buffer_pid, :pop_request)
  end

  def send_request(buffer_pid, request) do
    GenServer.call(buffer_pid, {:send_request, request})
  end

  def dump(buffer_pid) do
    GenServer.call(buffer_pid, :dump)
  end

  @initial_state %{messages: :queue.new(), requests: :queue.new(), awaiting_server: false}

  @impl GenServer
  def init(opts) do
    server = Keyword.get_lazy(opts, :server, fn -> link_server(opts) end)
    state = Map.merge(@initial_state, %{server: server, transport: opts[:transport]})

    {:ok, struct!(__MODULE__, state)}
  end

  defp link_server(opts) do
    server_opts =
      Keyword.take(opts, [:module])
      |> Keyword.merge(buffer: self())

    {:ok, server} = :proc_lib.start_link(GenSpring, :init, [server_opts])

    server
  end

  @impl GenServer
  def handle_call({:send_request, request}, _from, %__MODULE__{} = buffer) do
    result =
      with {:ok, message} <- Requests.encode(request) do
        Socket.send(buffer.transport, message)
      end

    {:reply, result, buffer}
  end

  @impl GenServer
  def handle_call(:dump, _from, %__MODULE__{} = buffer) do
    {:reply, buffer, buffer}
  end

  @impl GenServer
  def handle_cast({:push_messages, incoming_messages}, %__MODULE__{} = buffer) do
    incoming_messages = :queue.from_list(incoming_messages)
    messages = :queue.join(buffer.messages, incoming_messages)
    buffer = Map.put(buffer, :messages, messages)

    {:noreply, buffer, {:continue, :pop_message}}
  end

  @impl GenServer
  def handle_cast(:pop_request, buffer),
    do: handle_continue(:pop_request, buffer)

  @impl GenServer
  def handle_continue(:pop_message, %__MODULE__{} = buffer) do
    {popped, buffer} = :queue.out(buffer.messages) |> popped_message(buffer)

    case popped do
      :value when buffer.awaiting_server ->
        {:noreply, buffer, {:continue, :pop_message}}

      :value ->
        {:noreply, buffer, {:continue, :pop_request}}

      :empty ->
        {:noreply, buffer}
    end
  end

  @impl GenServer
  def handle_continue(
        :pop_request,
        %__MODULE__{awaiting_server: false} = buffer
      ) do
    {:pop_message, buffer} =
      :queue.out(buffer.requests)
      |> popped_request(buffer)

    {:noreply, buffer, {:continue, :pop_message}}
  end

  defp popped_message({{:value, message}, messages}, buffer) do
    request = Requests.decode(message)
    requests = :queue.in(request, buffer.requests)

    buffer = Map.merge(buffer, %{messages: messages, requests: requests})

    {:value, buffer}
  end

  defp popped_message({:empty, _messages}, buffer), do: {:empty, buffer}

  defp popped_request({{:value, request}, requests}, buffer) do
    case request do
      {:ok, request} -> send(buffer.server, {:request, request})
      {:error, error} -> send(buffer.server, {:error, error})
    end

    {:pop_message, Map.merge(buffer, %{requests: requests})}
  end

  defp popped_request({:empty, _requests}, buffer), do: {:pop_message, buffer}
end
