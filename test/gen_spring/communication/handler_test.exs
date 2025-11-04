defmodule GenSpring.Communication.HandlerTest do
  use ExUnit.Case

  test "greets the world" do
    {:ok, port} = start_handler()
    {:ok, client} = :gen_tcp.connect(:localhost, port, active: false)

    :gen_tcp.send(client, "Hello\n")
    {:ok, data} = :gen_tcp.recv(client, 0, 100)

    assert to_string(data) == "Hello"

    :gen_tcp.send(client, "Wor")

    :gen_tcp.send(client, "ld\nMerry\n")

    {:ok, data} = :gen_tcp.recv(client, 0, 100)

    assert to_string(data) == "World"

    :gen_tcp.send(client, "Christmas\n")

    {:ok, data} = :gen_tcp.recv(client, 0, 100)

    assert to_string(data) == "Merry Christmas"
  end

  @handler_defaults [port: 0, handler_module: GenSpring.Communication.Handler, num_acceptors: 1]

  defp start_handler(server_args \\ []) do
    server_args = Keyword.merge(@handler_defaults, server_args)

    {:ok, server_pid} = start_supervised({ThousandIsland, server_args})
    {:ok, {_ip, port}} = ThousandIsland.listener_info(server_pid)
    {:ok, port}
  end
end
