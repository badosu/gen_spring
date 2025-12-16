# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOINEDFROM do
  @moduledoc """
  Sent by the server in response to a successful 
   command.
  """

  words = [
    chan: [description: nil, optional: false],
    bridge: [description: nil, optional: false],
    username: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
