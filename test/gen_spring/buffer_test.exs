defmodule GenSpring.BufferTest do
  use ExUnit.Case
  use Mimic

  alias GenSpring.Requests
  alias GenSpring.Buffer
  alias ThousandIsland.Socket

  describe "&init/1" do
    defmodule MySpringServer do
      use GenServer

      @impl true
      def init(opts) do
        assert opts == [my: :opts]

        {:ok, %{}}
      end
    end

    test "when no server passed links to a new GenSpring instance" do
      module_opts = {MySpringServer, my: :opts}

      {:ok, state} = Buffer.init(module: module_opts, transport: :transport)

      assert match?(%{server: _, transport: :transport}, state)

      server_info = Process.info(state.server)

      assert match?({GenSpring, _, _}, Keyword.get(server_info, :current_function))
    end
  end

  describe "&push_messages/2" do
    test "sends requests to the server" do
      buffer = start_link_supervised!({Buffer, transport: :transport, server: self()})

      allow(Requests, self(), buffer)

      message_1 = "message_1"
      message_2 = "message_2"
      request_1 = %{request: :one}
      request_2 = %{request: :two}

      Requests
      |> expect(:decode, fn incoming_message ->
        assert incoming_message == message_1

        {:ok, request_1}
      end)
      |> expect(:decode, fn incoming_message ->
        assert incoming_message == message_2

        {:ok, request_2}
      end)

      Buffer.push_messages(buffer, [message_1, message_2])

      assert_receive {:request, ^request_1}
      assert_receive {:request, ^request_2}
      refute_receive _any

      %{requests: requests, messages: messages} = Buffer.dump(buffer)

      assert :queue.is_empty(requests)
      assert :queue.is_empty(messages)
    end

    test "sends errors when message is malformed" do
      buffer = start_link_supervised!({Buffer, transport: :transport, server: self()})

      allow(Requests, self(), buffer)

      message_1 = "message_1"
      request_1 = Requests.ParseError.exception(message_1)

      Requests
      |> expect(:decode, fn incoming_message ->
        assert incoming_message == message_1

        {:error, request_1}
      end)

      Buffer.push_messages(buffer, [message_1])

      assert_receive {:error, ^request_1}
      refute_receive _any

      %{requests: requests, messages: messages} = Buffer.dump(buffer)

      assert :queue.is_empty(requests)
      assert :queue.is_empty(messages)
    end
  end

  describe "&send_request/2" do
    test "sends requests to the server" do
      transport = :transport
      buffer = start_link_supervised!({Buffer, transport: transport, server: self()})

      allow(Requests, self(), buffer)

      message_1 = "message_1\n"
      request_1 = %{request: :one}

      Requests
      |> expect(:encode, fn outgoing_request ->
        assert outgoing_request == request_1

        {:ok, message_1}
      end)

      expect(Socket, :send, fn socket, data ->
        assert socket == transport
        assert data == message_1

        :ok
      end)

      assert :ok == Buffer.send_request(buffer, request_1)
    end

    test "sends errors when message is malformed" do
      buffer = start_link_supervised!({Buffer, transport: :transport, server: self()})

      allow(Requests, self(), buffer)
      allow(ThousandIsland.Socket, self(), buffer)

      message_1 = "message_1"
      request_1 = Requests.ParseError.exception(message_1)

      Requests
      |> expect(:decode, fn incoming_message ->
        assert incoming_message == message_1

        {:error, request_1}
      end)

      Buffer.push_messages(buffer, [message_1])

      assert_receive {:error, ^request_1}
      refute_receive _any

      %{requests: requests, messages: messages} = Buffer.dump(buffer)

      assert :queue.is_empty(requests)
      assert :queue.is_empty(messages)
    end
  end
end
