# codegen: do not edit
defmodule GenSpring.Requests.Exit do
  @moduledoc """
  Clients should send this as their last command before severing their connection to the server, to notify a clean and deliberate disconnect. The server is not required to acknowledge, or respond, to the exiting client. Other clients via server messages or status change commands.

  Source: client
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "EXIT"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
