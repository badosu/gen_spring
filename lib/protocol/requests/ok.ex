# codegen: do not edit
defmodule GenSpring.Requests.Ok do
  @moduledoc """
  Sent as the response to a STLS command. The client now can now start the tls connection. The server will send again the greeting TASSERVER.

  Source: server
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "OK"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
