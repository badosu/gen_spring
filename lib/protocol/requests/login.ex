# codegen: do not edit
defmodule GenSpring.Requests.Login do
  @moduledoc """
  Sent by a client asking to log on to the server. Note: if the client has not yet confirmed the user agreement, then server will send the AGREEMENT to the client as a response to this command. In this case the response to LOGIN will be delayed until after CONFIRMAGREEMENT. Also see LOGININFOEND command.

  Source: client
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "LOGIN"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
