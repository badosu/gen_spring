# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SAIDEX do
  @moduledoc """
  Sent by the server when a client said something
        using the 
   command.
  """

  words = [
    channame: [description: nil, optional: false],
    username: [description: nil, optional: false]
  ]

  sentences = [message: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
