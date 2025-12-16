# codegen: do not edit
defmodule GenSpring.Protocol.Requests.UNBRIDGECLIENTFROM do
  @moduledoc """
  Sent by a bridge bot notifying the server that a bridged client has left the bridge.
  """

  words = [
    location: [description: nil, optional: false],
    externalid: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
