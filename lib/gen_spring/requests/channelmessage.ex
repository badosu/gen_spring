# codegen: do not edit
defmodule GenSpring.Requests.Channelmessage do
  @moduledoc """
  Sent by the server to all clients in a channel.
        Used to broadcast messages in a channel.
  """

  words = [channame: [description: nil, optional: true],
 message: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
