defmodule GenSpring.Communication.TransportTest do
  use ExUnit.Case, async: true
  use Mimic

  alias GenSpring.Buffer
  alias GenSpring.Communication.Transport

  describe "&handle_connection/2" do
    test "connects to a buffer" do
      module_opts = {MySpringServer, my: :opts}

      expect(Buffer, :start_link, fn opts ->
        assert Keyword.fetch!(opts, :module) == module_opts

        {:ok, :buffer}
      end)

      assert {:continue, state} = Transport.handle_connection(:socket, module: module_opts)
      assert match?(%{msg_buffer: "", buffer: :buffer}, state)
    end
  end

  describe "&handle_data/2" do
    test "sends incoming messages to the buffer" do
      Buffer
      |> expect(:push_messages, fn :buffer, messages ->
        assert messages == ["Hello World", "Merry"]

        :ok
      end)
      |> expect(:push_messages, fn :buffer, messages ->
        assert messages == ["Christmas"]

        :ok
      end)

      state = %{msg_buffer: "", buffer: :buffer}

      result = Transport.handle_data("Hello", :socket, state)
      assert {:continue, state} = result
      result = Transport.handle_data(" Wor", :socket, state)
      assert {:continue, state} = result
      result = Transport.handle_data("ld\nMerry\n", :socket, state)
      assert {:continue, state} = result
      result = Transport.handle_data("Christmas\n...", :socket, state)
      assert {:continue, state} = result

      assert match?(%{msg_buffer: "...", buffer: :buffer}, state)
    end
  end
end
