defmodule SupervisorHelper do
  def await_child!(supervisor, timeout \\ 1000, poll_duration \\ 5) do
    try do
      Task.async(fn -> do_await_child(supervisor, poll_duration) end)
      |> Task.await(timeout)
    catch
      :exit, _ ->
        ExUnit.Assertions.flunk("Failed to register process")
    end
  end

  defp do_await_child(supervisor, poll_duration) do
    case Supervisor.which_children(supervisor) do
      [child] ->
        child

      _ ->
        Process.send_after(self(), :loop, poll_duration)

        receive do
          :loop ->
            do_await_child(supervisor, poll_duration)
        end
    end
  end
end
