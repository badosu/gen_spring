# codegen: do not edit
defmodule GenSpring.Protocol.Requests.UPDATEBOT do
  @moduledoc """
  Sent by the server notifying a client in the battle that one of the bots just got his status updated.
        Also see the 
   command.
  """

  words = [
    battleid: [description: nil, optional: false],
    name: [description: nil, optional: false],
    battlestatus: [description: nil, optional: false],
    teamcolor: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
