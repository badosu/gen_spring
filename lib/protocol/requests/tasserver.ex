# codegen: do not edit
defmodule GenSpring.Requests.Tasserver do
  @moduledoc """
  This is the first message (i.e. "greeting message") that a client receives upon connecting to the server.

  Source: server
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "TASSERVER"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
