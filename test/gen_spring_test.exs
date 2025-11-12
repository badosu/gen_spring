defmodule GenSpringTest do
  use ExUnit.Case, async: true

  test "implements the OTP behavior" do
    defmodule TestSpringServer do
      def init(opts) do
        {:ok, %{initial: :state}}
      end
    end

    {:ok, server} = GenSpring.start_link(buffer: self(), module: {TestSpringServer, []})

    assert :ok == :sys.suspend(server)
    assert :ok == :sys.resume(server)

    assert match?(
             %{mod: TestSpringServer, state: %{initial: :state}},
             :sys.get_state(server)
           )

    replaced_state =
      :sys.replace_state(server, fn spring -> put_in(spring.state, %{new: :state}) end)

    assert match?(%{server_state: %{new: :state}}, replaced_state)
    assert match?(^replaced_state, :sys.get_state(server))
  end

  test "" do
    defmodule TestSpringServer do
      def init(opts) do
        {:ok, %{initial: :state}}
      end
    end

    {:ok, server} = GenSpring.start_link(buffer: self(), module: {TestSpringServer, []})

    assert :ok == :sys.suspend(server)
    assert :ok == :sys.resume(server)

    assert match?(
             %{mod: TestSpringServer, state: %{initial: :state}},
             :sys.get_state(server)
           )

    replaced_state =
      :sys.replace_state(server, fn spring -> put_in(spring.state, %{new: :state}) end)

    assert match?(%{server_state: %{new: :state}}, replaced_state)
    assert match?(^replaced_state, :sys.get_state(server))
  end
end
