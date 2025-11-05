defmodule GenSpring.Communication.TransportTest do
  use ExUnit.Case
  use Mimic

  alias GenSpring.Communication.Buffer
  alias GenSpring.Communication.Transport

  describe "&handle_connection/2" do
    test "connects to a buffer" do
      expect(Buffer, :connect, fn :socket, :state -> {:ok, :buffer} end)

      assert {:continue, state} = Transport.handle_connection(:socket, :state)
      assert match?(%{msg_buffer: "", buffer: :buffer}, state)
    end
  end

  describe "&handle_data/2" do
    test "sends incoming messages to the buffer" do
      Buffer
      |> expect(:incoming, fn :buffer, "Hello World" -> nil end)
      |> expect(:incoming, fn :buffer, "Merry" -> nil end)
      |> expect(:incoming, fn :buffer, "Christmas" -> nil end)

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
