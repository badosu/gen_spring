defmodule TraceHelper do
  defmacro assert_traced_call(nil, _module, _expression), do: raise("hwot")

  defmacro assert_traced_call(tracer, func_spec, expression) do
    quote do
      {module, method} = unquote(func_spec)
      %{session: session, agent: agent} = unquote(tracer)

      case AgentHelper.await_value(agent, &Map.get(&1.calls, module)) do
        {:ok, [first_call | calls]} ->
          assert match?({method, unquote(expression)}, first_call)

          Agent.update(agent, &put_in(&1.calls[module], calls))

        {:error, :timeout} ->
          flunk("#{module} didn't receive any call")
      end
    end
  end

  def setup(%{trace: true, module: module, test_pid: test_pid}) do
    {:ok, agent} = Agent.start_link(fn -> %{calls: %{}} end)

    tracer = spawn(fn -> inject_agent_traces(agent) end)

    session_name = :"test.#{module}#{inspect(test_pid)}"
    session = :trace.session_create(session_name, tracer, [])
    %{session: session, tracer: tracer, agent: agent}
  end

  def setup(_options), do: nil

  def trace_calls(nil = _tracer, _pid, _module), do: raise("hwot")

  def trace_calls(%{session: session}, pid, module) do
    :trace.process(session, pid, true, [:call])
    :trace.function(session, {module, :_, :_}, [], [])
  end

  defp inject_agent_traces(agent) do
    receive do
      {:trace, _pid, :call, {module, method, args}} ->
        Agent.cast(agent, fn state ->
          state = update_in(state.calls, &Map.put_new(&1, module, []))

          update_in(state.calls[module], &(&1 ++ [{method, args}]))
        end)

        inject_agent_traces(agent)
    end
  end
end
