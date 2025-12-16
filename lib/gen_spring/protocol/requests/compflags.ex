# codegen: do not edit
defmodule GenSpring.Protocol.Requests.COMPFLAGS do
  @moduledoc """
  Sent as a response to a 
   command.
        The server sends a list of supported comp-flags that may be specified
        by the client on 
  .
  """

  words = [
    compflag1: [description: nil, optional: true],
    compflag2: [description: nil, optional: true],
    variadic: [description: nil, optional: true]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
