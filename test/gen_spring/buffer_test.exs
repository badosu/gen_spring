defmodule GenSpring.BufferTest do
  use ExUnit.Case, async: true
  use Mimic

  alias GenSpring.Communication.Transport
  alias GenSpring.Requests
  alias GenSpring.Buffer
  alias GenSpring.TransportError

  describe "&init/1" do
    test "links to a new GenSpring instance" do
      module_opts = {MySpringServer, my: :opts}
      me = self()

      GenSpring
      |> expect(:start_link, fn opts ->
        assert Keyword.fetch!(opts, :buffer) == me
        assert Keyword.fetch!(opts, :server) == module_opts

        {:ok, me}
      end)

      {:ok, state} = Buffer.init(server: module_opts, transport: :transport)

      assert %{server: ^me, transport: :transport} = state
    end
  end

  describe "&push_messages/2" do
    test "pops a request to the server" do
      buffer_name = TestBuffer

      buffer =
        start_link_supervised!({Buffer, transport: :transport, server: self(), name: buffer_name})

      message_1 = "message_1"
      message_2 = "message_2"
      request_1 = %{request: :one}
      request_2 = %{request: :two}

      Requests
      |> allow(self(), buffer)
      |> expect(:decode, fn incoming_message ->
        assert incoming_message == message_1

        {:ok, request_1}
      end)
      |> expect(:decode, fn incoming_message ->
        assert incoming_message == message_2

        {:ok, request_2}
      end)

      assert Buffer.push_messages(buffer, [message_1, message_2]) == :ok

      assert_receive {:request, ^request_1}

      assert [{:ok, ^request_2}] = :sys.get_state(buffer).request_queue |> :queue.to_list()
    end

    test "sends errors when message is malformed" do
      buffer =
        start_link_supervised!({Buffer, transport: :transport, server: self()})

      message_1 = "message_1"
      request_1 = GenSpring.ParseError.exception(message_1)

      Requests
      |> allow(self(), buffer)
      |> expect(:decode, fn incoming_message ->
        assert incoming_message == message_1

        {:error, request_1}
      end)

      Buffer.push_messages(buffer, [message_1])
      Buffer.pop_request(buffer)

      assert_receive {:error, ^request_1}
      refute_receive _any

      buffer_state = :sys.get_state(buffer)

      assert :queue.is_empty(buffer_state.request_queue)
    end
  end

  describe "&send_request/2" do
    test "sends requests to the client" do
      transport = :transport
      buffer = start_link_supervised!({Buffer, transport: transport, server: self()})
      stub_transport(transport, buffer)

      message_1 = "message_1"
      request_1 = %{request: :one}

      Requests
      |> allow(self(), buffer)
      |> expect(:encode, fn outgoing_request ->
        assert outgoing_request == request_1

        {:ok, message_1}
      end)

      Transport
      |> expect(:send, fn dest, data ->
        assert dest == transport
        assert data == message_1

        :ok
      end)

      assert :ok == Buffer.request(buffer, request_1)
    end

    test "returns encode errors" do
      transport = :transport
      buffer = start_link_supervised!({Buffer, transport: transport, server: self()})
      stub_transport(transport, buffer)

      request_1 = %{request: :one}
      error_1 = GenSpring.EncodeError.exception(request_1)

      Requests
      |> allow(self(), buffer)
      |> expect(:encode, fn outgoing_request ->
        assert outgoing_request == request_1

        {:error, error_1}
      end)

      assert {:error, error_1} == Buffer.request(buffer, request_1)
    end

    test "returns transport errors" do
      transport = :transport
      buffer = start_link_supervised!({Buffer, transport: transport, server: self()})
      stub_transport(transport, buffer)

      request_1 = %{request: :one}
      message_1 = "message_1"

      Requests
      |> allow(self(), buffer)
      |> expect(:encode, fn outgoing_request ->
        assert outgoing_request == request_1

        {:ok, message_1}
      end)

      error_return = {:error, TransportError.exception(:closed)}

      Transport
      |> expect(:send, fn dest, msg ->
        assert dest == transport
        assert msg == message_1

        error_return
      end)

      assert error_return == Buffer.request(buffer, request_1)
    end
  end

  defp stub_transport(transport, buffer) do
    Transport
    |> allow(self(), buffer)
    |> stub(:close, fn dest, {exception, stacktrace} ->
      assert dest == transport

      reraise exception, stacktrace
    end)
  end
end
