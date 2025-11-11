defmodule GenSpringTest do
  use ExUnit.Case, async: true

  test "behaves as an OTP server" do
    defmodule TestSpringServer do
      def init(_opts) do
        {:ok, %{my: :state}}
      end
    end

    {:ok, server} = GenSpring.start_link(buffer: self(), module: {TestSpringServer, []})

    assert :ok == :sys.suspend(server)
    assert :ok == :sys.resume(server)

    assert match?(%{mod: TestSpringServer, server_state: %{my: :state}}, :sys.get_state(server))

    replaced_state =
      :sys.replace_state(server, fn state -> put_in(state.server_state, %{new: :state}) end)

    assert match?(%{server_state: %{new: :state}}, replaced_state)
    assert match?(^replaced_state, :sys.get_state(server))
  end
end
