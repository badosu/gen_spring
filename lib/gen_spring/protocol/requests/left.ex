# codegen: do not edit
defmodule GenSpring.Protocol.Requests.LEFT do
  @moduledoc """
  Sent by the server to inform a client, present in a channel, that another user or himself has left that channel.
  """

  words = [
    channame: [description: nil, optional: false],
    username: [description: nil, optional: false]
  ]

  sentences = [reason: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
