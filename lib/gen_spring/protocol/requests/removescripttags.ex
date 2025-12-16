# codegen: do not edit
defmodule GenSpring.Protocol.Requests.REMOVESCRIPTTAGS do
  @moduledoc """
  Relayed from battle host's 
   message.
        A client lobby program has to remove these from the GUI presenting
        current battle configuration to the player.
  """

  words = [
    key1: [description: nil, optional: false],
    key2: [description: nil, optional: true],
    key3: [description: nil, optional: true],
    variadic: [description: nil, optional: true]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
