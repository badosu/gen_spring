# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SETSCRIPTTAGS do
  @moduledoc """
  Relayed from battle host's 
   message.
        A client lobby program must process these tags and apply them accordingly
        to the GUI presenting current battle configuration to the player.

        All keys are made lowercase by the server.
  """

  words = []

  sentences = [
    pair1: [description: nil, optional: false],
    pair2: [description: nil, optional: true],
    pair3: [description: nil, optional: true],
    variadic: [description: nil, optional: true]
  ]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
