# codegen: do not edit
defmodule GenSpring.Requests.Compflags do
  @moduledoc """
  Sent as a response to a 
   command.
        The server sends a list of supported comp-flags that may be specified
        by the client on 
  .
  """

  words = [compflag1: [description: nil, optional: false],
 compflag2: [description: nil, optional: false],
 variadic: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
