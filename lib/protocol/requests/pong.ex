# codegen: do not edit
defmodule GenSpring.Requests.Pong do
  @moduledoc """
  Sent as the response to a PING command.

  Source: server
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "PONG"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
