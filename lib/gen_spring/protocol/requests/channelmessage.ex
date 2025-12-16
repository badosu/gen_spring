# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CHANNELMESSAGE do
  @moduledoc """
  Sent by the server to all clients in a channel.
        Used to broadcast messages in a channel.
  """

  words = [
    channame: [description: nil, optional: false],
    message: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
