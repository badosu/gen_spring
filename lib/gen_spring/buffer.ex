defmodule GenSpring.Buffer do
  use GenServer
  use TypedStruct

  alias GenSpring.Requests
  alias ThousandIsland.Socket

  defmodule TransportError do
    defexception [:message, :reason]

    @impl Exception
    def exception(reason) do
      message = "Failed to communicate with transport"

      %__MODULE__{message: message, reason: reason}
    end
  end

  @type request_result() :: {:ok, Request.t()} | {:error, Requests.ParseError.t()}
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

  @initial_state %{messages: :queue.new(), requests: :queue.new(), awaiting_server: false}

  @impl GenServer
  def init(opts) do
    {:ok, server} = start_server(opts)

    state = Map.merge(@initial_state, %{server: server, transport: opts[:transport]})

    {:ok, struct!(__MODULE__, state)}
  end

  @impl GenServer
  def handle_call({:send_request, request}, _from, %__MODULE__{} = buffer) do
    result =
      with {:ok, message} <- Requests.encode(request) do
        transport_send(buffer, message)
      end

    {:reply, result, buffer}
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
    case :queue.out(buffer.messages) do
      {:empty, _messages} ->
        {:noreply, buffer}

      {{:value, message}, messages} ->
        request = Requests.decode(message)
        requests = :queue.in(request, buffer.requests)
        buffer = Map.merge(buffer, %{messages: messages, requests: requests})
        continuation = if buffer.awaiting_server, do: :pop_message, else: :pop_request

        {:noreply, buffer, {:continue, continuation}}
    end
  end

  @impl GenServer
  def handle_continue(
        :pop_request,
        %__MODULE__{awaiting_server: false} = buffer
      ) do
    buffer =
      case :queue.out(buffer.requests) do
        {:empty, _messages} ->
          buffer

        {{:value, {:ok, request}}, requests} ->
          send(buffer.server, {:request, request})

          Map.merge(buffer, %{requests: requests})

        {{:value, {:error, error}}, requests} ->
          send(buffer.server, {:error, error})

          Map.merge(buffer, %{requests: requests})
      end

    {:noreply, buffer, {:continue, :pop_message}}
  end

  defp start_server(opts) do
    if Keyword.has_key?(opts, :server),
      do: Keyword.fetch(opts, :server),
      else: GenSpring.start_link(buffer: self(), module: Keyword.fetch!(opts, :module))
  end

  defp transport_send(buffer, message) do
    with {:error, error} <- Socket.send(buffer.transport, "#{message}\n") do
      {:error, TransportError.exception(error)}
    end
  end
end
