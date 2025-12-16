# defmodule GenSpring.Application do
#   # See https://hexdocs.pm/elixir/Application.html
#   # for more information on OTP Applications
#   @moduledoc false
#
#   use Application
#
#   @args_schema NimbleOptions.new!(
#                  server: [
#                    type: :mod_arg,
#                    required: true,
#                    doc:
#                      "A `{module, args}` tuple, where `module` implements `GenSpring` and instantiates with `args`."
#                  ],
#                  transport: [
#                    type: :keyword_list,
#                    required: true
#                  ],
#                  name: [
#                    type: :any,
#                    doc:
#                      "Used for name registration as described in the \"Name registration\" section in the documentation for `GenServer`."
#                  ]
#                )
#
#   @impl Application
#   def start(_type, args) do
#     NimbleOptions.validate!(args, @args_schema)
#
#     Supervisor.start_link(
#       children(args),
#       strategy: :one_for_one,
#       name: GenSpring.Supervisor
#     )
#   end
#
#   def children(args) do
#     [
#       # buffer_registry_child_spec(),
#       # buffer_supervisor_child_spec(),
#       transport_child_spec(args),
#       genspring_supervisor_child_spec()
#     ]
#   end
#
#   defp transport_child_spec(options) do
#     server_options = Keyword.fetch!(options, :server)
#     transport_options = Keyword.get(options, :transport, [])
#
#     transport_options =
#       [port: 9090]
#       |> Keyword.merge(transport_options)
#       |> Keyword.merge(
#         handler_module: GenSpring.Communication.Transport,
#         handler_options: [
#           server: server_options
#         ]
#       )
#
#     {ThousandIsland, transport_options}
#   end
#
#   defp genspring_supervisor_child_spec(options \\ []) do
#     default_options = [name: GenSpring.ServerSupervisor, strategy: :one_for_one]
#     {DynamicSupervisor, Keyword.merge(default_options, options)}
#   end
#
#   # defp buffer_supervisor_child_spec(options \\ []) do
#   #   default_options = [name: GenSpring.BufferSupervisor, strategy: :one_for_one]
#   #   {DynamicSupervisor, Keyword.merge(default_options, options)}
#   # end
#   #
#   # defp buffer_registry_child_spec(options \\ []) do
#   #   default_options = [keys: :unique, name: GenSpring.BufferRegistry]
#   #   {Registry, Keyword.merge(default_options, options)}
#   # end
# end
