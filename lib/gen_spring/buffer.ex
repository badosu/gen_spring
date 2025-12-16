defmodule GenSpring.Buffer do
  use GenServer
  use TypedStruct

  alias GenSpring.Communication.Transport
  alias GenSpring.Protocol.Requests

  @type request_result() :: {:ok, any()} | {:error, GenSpring.ParseError.t()}
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
    with {:ok, messages} <- encode_requests(requests) do
      GenServer.call(buffer_pid, {:request, messages})
    end
  end

  def close(buffer_pid, reason) do
    GenServer.stop(buffer_pid, reason)
  end

  @impl GenServer
  def init(opts) do
    case start_server(opts) do
      {:ok, server} ->
        state = initial_state(server, Keyword.fetch!(opts, :transport))

        Process.monitor(server)

        {:ok, state}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  @impl GenServer
  def terminate(reason, buffer) do
    # FIXME: devise how/whether GenSpring server handles error closing the
    # socket and ensure we always exit it

    :sys.terminate(buffer.server, reason)

    # unhandled_requests = buffer.request_queue |> :queue.to_list() |> Enum.map(&elem(&1, 1))
    # reason =
    #   if Enum.empty?(unhandled_requests),
    #     do: reason,
    #     else: {reason, unhandled_requests: unhandled_requests}
  end

  @impl GenServer
  def handle_info(:pop_request, state), do: {:continue, :pop_request, state}

  @impl true
  def handle_info({:EXIT, _from, _reason}, state) do
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:DOWN, _ref, :process, pid, reason}, %__MODULE__{server: server} = state)
      when pid == server do
    {:stop, reason, state}
  end

  @impl GenServer
  def handle_info(info, state) do
    dbg(info)

    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:request, messages}, _from, %__MODULE__{} = buffer) do
    {:reply, send_messages(buffer, messages), buffer}
  end

  @impl GenServer
  def handle_cast({:push_messages, incoming_messages}, %__MODULE__{} = buffer) do
    incoming_requests =
      incoming_messages
      |> Enum.map(&GenSpring.Protocol.Requests.decode/1)
      |> :queue.from_list()

    request_queue = :queue.join(buffer.request_queue, incoming_requests)
    buffer = Map.put(buffer, :request_queue, request_queue)

    {:noreply, buffer, {:continue, :pop_request}}
  end

  @impl GenServer
  def handle_cast(:pop_request, buffer),
    do: handle_continue(:pop_request, buffer)

  @impl GenServer
  def handle_continue(:pop_request, buffer) do
    # if GenSpring.shutting_down?(buffer.server),
    #   do: {:noreply, buffer},
    {:noreply, do_pop_request(buffer, :queue.out(buffer.request_queue))}
  end

  defp start_server(opts) do
    case Keyword.fetch!(opts, :server) do
      server when is_pid(server) ->
        {:ok, server}

      {handler_module, handler_opts} ->
        Process.flag(:trap_exit, true)

        GenSpring.Server.start_child(GenSpring.Handler, self(), handler_module, handler_opts)
    end
  end

  @initial_state %{request_queue: :queue.new()}
  defp initial_state(server, transport) do
    state = Map.merge(@initial_state, %{server: server, transport: transport})

    struct!(__MODULE__, state)
  end

  defp encode_requests(requests) do
    requests
    |> List.wrap()
    |> Enum.reduce_while({:ok, []}, fn request, {:ok, messages} ->
      case Requests.encode(request) do
        {:ok, message} ->
          {:cont, {:ok, messages ++ [message]}}

        {:error, error} ->
          {:halt, {:error, error}}
      end
    end)
  end

  defp send_messages(buffer, [message]),
    do: transport_send(buffer, message)

  defp send_messages(buffer, messages) do
    messages
    |> Enum.reduce_while([], fn message, {:ok, messages_sent} ->
      case transport_send(buffer, message) do
        {:error, error} ->
          error = Map.merge(error, %{sent: messages_sent, failed: message})

          {:halt, {:error, error}}

        :ok ->
          {:cont, {:ok, messages_sent ++ [message]}}
      end
    end)
    |> case do
      {:ok, _messages_sent} -> :ok
      {:error, error} -> {:error, error}
    end
  end

  defp transport_send(buffer, message), do: Transport.send(buffer.transport, message)

  defp do_pop_request(buffer, {:empty, _requests}), do: buffer

  defp do_pop_request(buffer, {{:value, {:ok, request}}, requests}) do
    send(buffer.server, {:request, request})
    Map.put(buffer, :request_queue, requests)
  end

  defp do_pop_request(buffer, {{:value, {:error, request}}, request_queue}) do
    send(buffer.server, {:error, request})
    Map.put(buffer, :request_queue, request_queue)
  end
end
