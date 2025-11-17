defmodule Test.Support.GenSpring do
  def test_server_module(module),
    do: Module.concat(TestSpring, module)

  defmacro defserver(module, test_pid \\ nil, do: expression) do
    quote do
      defmodule unquote(module) do
        use GenSpring

        @test_pid unquote(test_pid)

        @impl GenSpring
        def handle_request(_request, _buffer, state), do: {:noreply, state}

        defoverridable handle_request: 3

        unquote(expression)
      end
    end
  end
end
