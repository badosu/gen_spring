defmodule AgentHelper do
  def await_value(agent, getter, timeout \\ 1000, poll_duration \\ 5) do
    try do
      Task.async(fn -> do_await_value(agent, getter, poll_duration) end)
      |> Task.await(timeout)
    catch
      :exit, _reason ->
        {:error, :timeout}
    end
  end

  def do_await_value(agent, getter, poll_duration) do
    case Agent.get(agent, getter) do
      value when value in [nil, []] ->
        Process.send_after(self(), :loop, poll_duration)

        receive do
          :loop ->
            do_await_value(agent, getter, poll_duration)
        end

      value ->
        {:ok, value}
    end
  end
end
