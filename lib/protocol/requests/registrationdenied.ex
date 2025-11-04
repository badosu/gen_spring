# codegen: do not edit
defmodule GenSpring.Requests.Registrationdenied do
  @moduledoc """
  Sent in response to a REGISTER command, if registration has been refused.

  Source: server
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "REGISTRATIONDENIED"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
