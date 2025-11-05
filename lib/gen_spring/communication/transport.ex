defmodule GenSpring.Communication.Transport do
  alias GenSpring.Communication.Buffer
  use ThousandIsland.Handler

  @impl ThousandIsland.Handler
  def handle_connection(socket, state) do
    {:ok, buffer} = Buffer.connect(socket, state)

    {:continue, %{msg_buffer: "", buffer: buffer}}
  end

  @impl ThousandIsland.Handler
  def handle_data(data, _socket, %{msg_buffer: msg_buffer, buffer: buffer} = state) do
    {msg_buffer, messages} = get_buffer_and_messages(msg_buffer, data)

    for message <- messages,
        do: Buffer.incoming(buffer, message)

    {:continue, Map.put(state, :msg_buffer, msg_buffer)}
  end

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
