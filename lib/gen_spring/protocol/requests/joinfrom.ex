# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOINFROM do
  @moduledoc """
  Send by a bridge bot requesting to join a bridged client to a channel.
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
