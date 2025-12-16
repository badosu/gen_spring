# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SAIDFROM do
  @moduledoc """
  Sent by the server in response to a successful 
   command.
  """

  words = [
    chan: [description: nil, optional: false],
    username: [description: nil, optional: false]
  ]

  sentences = [message: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
