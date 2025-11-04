# codegen: do not edit
defmodule GenSpring.Requests.Stls do
  @moduledoc """
  Initiate a TLS connection to the server.

  Source: client
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "STLS"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
