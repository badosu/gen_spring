defmodule GenSpring.Communication.Transport do
  use ThousandIsland.Handler

  alias GenSpring.Buffer

  @impl ThousandIsland.Handler
  def handle_connection(_socket, state) do
    buffer_opts = Keyword.take(state, [:module, :buffer_name])
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
    Buffer.close(state.buffer, :closed)
  end

  # NOTE: When the connection is closed client side (reason = :closed), we
  # don't need to stop the transport
  def close(_transport, :closed),
    do: :ok

  def close(transport, reason),
    do: GenServer.stop(transport, {:shutdown, reason})

  defdelegate send(transport, message), to: ThousandIsland.Socket

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
