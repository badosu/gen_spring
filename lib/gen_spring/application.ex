defmodule GenSpring.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @args_schema NimbleOptions.new!(
                 server_module: [
                   type: :mod_arg,
                   required: true,
                   doc:
                     "A `{module, args}` tuple, where `module` implements `GenSpring` and instantiates with `args`."
                 ],
                 name: [
                   type: :any,
                   doc:
                     "Used for name registration as described in the \"Name registration\" section in the documentation for `GenServer`."
                 ]
               )

  @impl Application
  def start(_type, args) do
    NimbleOptions.validate!(args, @args_schema)

    Supervisor.start_link(children(args), strategy: :one_for_one, name: GenSpring.Supervisor)
  end

  def children(args) do
    [
      buffer_registry_child_spec(),
      buffer_supervisor_child_spec(),
      transport_child_spec(args)
    ]
  end

  def transport_child_spec(options) do
    default_options = [port: 1234, handler_module: GenSpring.Communication.Transport]
    handler_options = Keyword.take(options, [:server_module])
    {ThousandIsland, Keyword.merge(default_options, handler_options: handler_options)}
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
