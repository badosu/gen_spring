# codegen: do not edit
defmodule GenSpring.Protocol.Requests.LEAVEFROM do
  @moduledoc """
  Sent by a bridge bot requesting to remove a bridged client from a channel.
  """

  words = [
    chan: [description: nil, optional: false],
    location: [description: nil, optional: false],
    externalid: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
