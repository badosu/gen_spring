# codegen: do not edit
defmodule GenSpring.Protocol.Requests.AGREEMENTEND do
  @moduledoc """
  Sent by the server after multiple 
   commands.
        This way, the server tells the client that he has finished sending the agreement
        (this is the time when the lobby client should popup the "agreement" screen
        and wait for the user to accept/reject it).
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
