# codegen: do not edit
defmodule GenSpring.Requests.Removescripttags do
  @moduledoc """
  Relayed from battle host's 
   message.
        A client lobby program has to remove these from the GUI presenting
        current battle configuration to the player.
  """

  words = [key1: [description: nil, optional: true],
 key2: [description: nil, optional: false],
 key3: [description: nil, optional: false],
 variadic: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
