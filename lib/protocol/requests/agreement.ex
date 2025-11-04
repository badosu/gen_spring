# codegen: do not edit
defmodule GenSpring.Requests.Agreement do
  @moduledoc """
  Sent by the server upon receiving a LOGIN command, if the client has not yet agreed to the server's "terms-of-use". The server may send multiple AGREEMENT commands, each of corresponds to a new line in the agreement text, finishing with an AGREEMENTEND command. The client should send CONFIRMAGREEMENT and then resend the LOGIN command, or disconnect from the server if he has chosen to refuse the agreement.

  Source: server
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "AGREEMENT"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
