defmodule GenSpring.Communication.TransportTest do
  use ExUnit.Case, async: true
  use Mimic

  alias GenSpring.Buffer
  alias GenSpring.Communication.Transport

  describe "&handle_connection/2" do
    test "connects to a buffer" do
      module_opts = {MySpringServer, my: :opts}

      expect(Buffer, :start_link, fn opts ->
        assert Keyword.fetch!(opts, :server) == module_opts

        {:ok, :buffer}
      end)

      assert {:continue, :buffer} = Transport.handle_connection(:socket, server: module_opts)
    end
  end

  describe "&handle_data/2" do
    test "sends incoming messages to the buffer" do
      Buffer
      |> expect(:push_messages, fn :buffer, messages ->
        assert messages == ["Hello World"]

        :ok
      end)
      |> expect(:push_messages, fn :buffer, messages ->
        assert messages == ["Merry Christmas"]

        :ok
      end)

      assert {:continue, :buffer} = Transport.handle_data("Hello World", :socket, :buffer)
      assert {:continue, :buffer} = Transport.handle_data("Merry Christmas", :socket, :buffer)
    end
  end
end
