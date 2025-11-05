defmodule SupervisorHelper do
  def supervision_tree(supervisor) do
    make_supervision_tree(supervisor)
  end

  defp make_supervision_tree(supervisor) do
    Enum.reduce(Supervisor.which_children(supervisor), [], fn child_spec, acc ->
      {id, pid, type, modules} = child_spec

      child = [id: id, pid: pid, modules: modules]

      if type == :supervisor do
        [child ++ [supervised: make_supervision_tree(pid)] | acc]
      else
        [child | acc]
      end
    end)
  end

  def await_child(supervisor, modules, timeout \\ 1000, poll_duration \\ 5) do
    try do
      Task.async(fn -> do_await_child(supervisor, modules, poll_duration) end)
      |> Task.await(timeout)
    catch
      :exit, _ ->
        nil
    end
  end

  defp do_await_child(supervisor, modules, poll_duration) do
    case Supervisor.which_children(supervisor) do
      [] ->
        Process.send_after(self(), :loop, poll_duration)

        receive do
          :loop ->
            do_await_child(supervisor, modules, poll_duration)
        end

      [child] when modules == nil ->
        child

      children ->
        child =
          Enum.find(
            children,
            fn child -> Enum.any?(modules, &(elem(child, 3) in &1)) end
          )

        if child == nil do
          Process.send_after(self(), :loop, poll_duration)

          receive do
            :loop ->
              do_await_child(supervisor, modules, poll_duration)
          end
        else
          child
        end
    end
  end
end
