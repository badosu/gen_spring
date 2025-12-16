defmodule GenSpring.Communication.Transport do
  alias GenSpring.Buffer
  alias GenSpring.TransportError
  alias ThousandIsland.Socket

  require Logger

  use ThousandIsland.Handler

  def send(transport, message), do: GenServer.call(transport, {:send, message})

  @impl ThousandIsland.Handler
  def handle_connection(_socket, opts) do
    buffer_opts = opts |> Keyword.take([:server]) |> Keyword.put(:transport, self())

    case Buffer.start_link(buffer_opts) do
      {:ok, buffer} ->
        {:continue, buffer}

      {:error, %GenSpring.InitError{}} ->
        {:close, nil}

      {:error, reason} ->
        {:error, reason, nil}
    end
  end

  @impl ThousandIsland.Handler
  def handle_error(%GenSpring.InitError{reason: _reason}, _socket, _buffer) do
    # Logger.error("WOPS: #{inspect(reason)}")
  end

  @impl ThousandIsland.Handler
  def handle_error(reason, _socket, buffer) when is_pid(buffer) do
    Buffer.close(buffer, {:transport_error, reason})
  end

  @impl ThousandIsland.Handler
  def handle_close(_socket, nil) do
    # Buffer already closed
  end

  @impl ThousandIsland.Handler
  def handle_close(_socket, buffer) do
    Buffer.close(buffer, {:shutdown, :transport_closed})
  end

  @impl ThousandIsland.Handler
  def handle_shutdown(_socket, buffer) do
    if Process.alive?(buffer) do
      Buffer.close(buffer, :shutdown)
    end
  end

  @impl ThousandIsland.Handler
  def handle_data(data, _socket, buffer) do
    messages = [String.trim_trailing(data)]
    :ok = Buffer.push_messages(buffer, messages)

    {:continue, buffer}
  end

  @impl true
  def handle_call({:send, message}, from, {socket, buffer}) do
    Task.start(fn ->
      GenServer.reply(from, transport_send(socket, message))
    end)

    {:noreply, {socket, buffer}}
  end

  @impl true
  def handle_info({:EXIT, _from, _reason}, buffer) do
    # we handle on handle_shutdown
    {:noreply, buffer}
  end

  defp transport_send(socket, message) do
    case Socket.send(socket, message) do
      :ok ->
        :ok

      {:error, error} ->
        {:error, TransportError.exception(error)}
    end
  end

  # defp get_buffer_and_messages("" = _msg_buffer, data) do
  #   segments = String.split(data, "\n") |> Enum.reject(&(&1 == ""))
  #
  #   if String.last(data) == "\n" do
  #     {"", segments}
  #   else
  #     List.pop_at(segments, -1)
  #   end
  # end
  #
  # defp get_buffer_and_messages(msg_buffer, data),
  #   do: get_buffer_and_messages("", msg_buffer <> data)
end
