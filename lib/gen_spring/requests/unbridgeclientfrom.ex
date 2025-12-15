# codegen: do not edit
defmodule GenSpring.Requests.Unbridgeclientfrom do
  @moduledoc """
  Sent by a bridge bot notifying the server that a bridged client has left the bridge.
  """

  words = [location: [description: nil, optional: true],
 externalid: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
