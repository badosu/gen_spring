defmodule GenSpring.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    Supervisor.start_link(children(), strategy: :one_for_one, name: GenSpring.Supervisor)
  end

  def children() do
    [
      buffer_registry_child_spec(),
      buffer_supervisor_child_spec(),
      transport_child_spec()
    ]
  end

  def transport_child_spec(options \\ []) do
    default_options = [port: 1234, handler_module: GenSpring.Communication.Transport]
    {ThousandIsland, Keyword.merge(default_options, options)}
  end

  def buffer_supervisor_child_spec(options \\ []) do
    default_options = [name: GenSpring.BufferSupervisor, strategy: :one_for_one]
    {DynamicSupervisor, Keyword.merge(default_options, options)}
  end

  def buffer_registry_child_spec(options \\ []) do
    default_options = [keys: :unique, name: GenSpring.BufferRegistry]
    {Registry, Keyword.merge(default_options, options)}
  end
end
