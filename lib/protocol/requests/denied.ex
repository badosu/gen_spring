# codegen: do not edit
defmodule GenSpring.Requests.Denied do
  @moduledoc """
  Sent as a response to a failed LOGIN command.

  Source: server
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "DENIED"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
