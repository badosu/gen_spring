# codegen: do not edit
defmodule GenSpring.Requests.Ping do
  @moduledoc """
  Requests a PONG back from the server. Clients should send PING once every 30 seconds, if no other data is being sent to the server. For details, see the notes above on keep-alive signals.

  Source: client
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "PING"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
