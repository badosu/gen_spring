defmodule GenSpring.Communication.Transport do
  use ThousandIsland.Handler

  alias GenSpring.Buffer
  alias GenSpring.TransportError
  alias ThousandIsland.Socket

  def send(transport, message), do: GenServer.call(transport, {:send, message})

  # NOTE: When the connection is closed client side (reason = :closed), we
  # don't need to stop the transport
  def close(_transport, :closed),
    do: :ok

  def close(transport, reason),
    do: GenServer.stop(transport, {:shutdown, reason})

  @impl ThousandIsland.Handler
  def handle_connection(_socket, opts) do
    buffer_opts = opts |> Keyword.take([:server]) |> Keyword.put(:transport, self())
    {:ok, buffer} = Buffer.start_link(buffer_opts)

    {:continue, %{msg_buffer: "", buffer: buffer}}
  end

  @impl ThousandIsland.Handler
  def handle_data(data, _socket, state) do
    {msg_buffer, messages} = get_buffer_and_messages(state.msg_buffer, data)

    if not Enum.empty?(messages) do
      :ok = Buffer.push_messages(state.buffer, messages)
    end

    {:continue, Map.put(state, :msg_buffer, msg_buffer)}
  end

  @impl ThousandIsland.Handler
  def handle_close(_socket, state) do
    dbg(:hwooo)
    Buffer.close(state.buffer, :closed)
  end

  @impl ThousandIsland.Handler
  def handle_shutdown(_socket, state) do
    dbg(:hwooo)
    Buffer.close(state.buffer, :closed)
  end

  @impl true
  def handle_call({:send, message}, from, {socket, state}) do
    Task.async(fn ->
      GenServer.reply(from, transport_send(socket, message))
    end)

    {:noreply, {socket, state}}
  end

  defp transport_send(socket, message) do
    with {:error, error} <- Socket.send(socket, "#{message}\n") do
      {:error, TransportError.exception(error)}
    end
  end

  defp get_buffer_and_messages("" = _msg_buffer, data) do
    segments = String.split(data, "\n") |> Enum.reject(&(&1 == ""))

    if String.last(data) == "\n" do
      {"", segments}
    else
      List.pop_at(segments, -1)
    end
  end

  defp get_buffer_and_messages(msg_buffer, data),
    do: get_buffer_and_messages("", msg_buffer <> data)
end
