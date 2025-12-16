# codegen: do not edit
defmodule GenSpring.Protocol.Requests.BRIDGECLIENTFROM do
  @moduledoc """
  Sent by a bridge bot notifying the server of a new bridged client.
  """

  words = [
    location: [description: nil, optional: false],
    externalid: [description: nil, optional: false],
    externalusername: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
