# codegen: do not edit
defmodule GenSpring.Requests.Updatebot do
  @moduledoc """
  Sent by the server notifying a client in the battle that one of the bots just got his status updated.
        Also see the 
   command.
  """

  words = [battleid: [description: nil, optional: true],
 name: [description: nil, optional: true],
 battlestatus: [description: nil, optional: true],
 teamcolor: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
