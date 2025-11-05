defmodule GenSpring do
  @moduledoc """
  Documentation for `GenSpring`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> GenSpring.hello()
      :world

  """
  def request_server(pid, request) do
    from = self()
    message = {:request, from, request}
    send(pid, message)
  end
end
