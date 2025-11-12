defmodule GenSpring.Buffer do
  use GenServer
  use TypedStruct

  alias GenSpring.Requests
  alias ThousandIsland.Socket

  defmodule TransportError do
    @type transport_send_reason() :: :closed | {:timeout, rest_data :: binary()} | :inet.posix()
    @type reason() :: transport_send_reason() | term()

    defexception [:message, :reason, :index]

    @impl Exception
    def exception(reason, index \\ nil) do
      message = "Failed to communicate with transport"

      %__MODULE__{message: message, reason: reason, index: index}
    end
  end

  @type request_result() :: {:ok, Request.t()} | {:error, Requests.ParseError.t()}
  @type request_queue() :: {List.t(request_result()), List.t(request_result())}

  typedstruct do
    field(:request_queue, request_queue(), enforce: true)
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

  def request(buffer_pid, requests) do
    GenServer.call(buffer_pid, {:request, List.wrap(requests)})
  end

  def stop(buffer_pid, reason) do
    GenServer.stop(buffer_pid, reason)
  end

  @initial_state %{request_queue: :queue.new()}

  @impl GenServer
  def init(opts) do
    {:ok, server} = start_server(opts)

    state = Map.merge(@initial_state, %{server: server, transport: opts[:transport]})

    {:ok, struct!(__MODULE__, state)}
  end

  @impl GenServer
  def terminate(reason, buffer) do
    # NOTE: Except when the connection is closed client side, we must close the
    # socket before terminating the buffer and GenSpring server
    if reason != :closed do
      # FIXME: devise how/whether server handles error closing the socket
      :ok = Socket.close(buffer.socket)
    end

    unhandled_requests = buffer.request_queue |> :queue.to_list() |> Enum.map(&elem(&1, 1))

    Process.exit(buffer.server, {reason, unhandled_requests})
  end

  @impl GenServer
  def handle_call({:request, requests}, _from, %__MODULE__{} = buffer),
    do: {:reply, send_requests(buffer, requests), buffer}

  @impl GenServer
  def handle_cast({:push_messages, incoming_messages}, %__MODULE__{} = buffer) do
    incoming_requests =
      incoming_messages
      |> Enum.map(&Requests.decode/1)
      |> :queue.from_list()

    request_queue = :queue.join(buffer.request_queue, incoming_requests)
    buffer = Map.put(buffer, :request_queue, request_queue)

    {:noreply, buffer, {:continue, :pop_request}}
  end

  @impl GenServer
  def handle_cast(:pop_request, buffer),
    do: handle_continue(:pop_request, buffer)

  @impl GenServer
  def handle_continue(:pop_request, buffer),
    do: {:noreply, do_pop_request(buffer)}

  defp start_server(opts) do
    if Keyword.has_key?(opts, :server),
      do: Keyword.fetch(opts, :server),
      else: GenSpring.start_link(buffer: self(), module: Keyword.fetch!(opts, :module))
  end

  defp send_requests(buffer, [request]),
    do: transport_send(buffer, request)

  defp send_requests(buffer, requests) do
    requests
    |> Enum.with_index()
    |> Enum.reduce_while(:ok, fn {index, request}, :ok ->
      case transport_send(buffer, request) do
        {:error, error} ->
          {:halt, {:error, Map.put(error, :index, index)}}

        :ok ->
          {:cont, :ok}
      end
    end)
  end

  defp transport_send(buffer, message) do
    with {:error, error} <- Socket.send(buffer.transport, "#{message}\n") do
      {:error, TransportError.exception(error)}
    end
  end

  defp do_pop_request(buffer), do: do_pop_request(buffer, :queue.out(buffer.requests))
  defp do_pop_request(buffer, {:empty, _requests}), do: buffer

  defp do_pop_request(buffer, {{:value, {:ok, request}}, requests}) do
    send(buffer.server, {:request, request})
    Map.put(buffer, :requests, requests)
  end

  defp do_pop_request(buffer, {{:value, {:error, request}}, request_queue}) do
    send(buffer.server, {:error, request})
    Map.put(buffer, :request_queue, request_queue)
  end
end
