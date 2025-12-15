# codegen: do not edit
defmodule GenSpring.Requests.Bridgeclientfrom do
  @moduledoc """
  Sent by a bridge bot notifying the server of a new bridged client.
  """

  words = [location: [description: nil, optional: true],
 externalid: [description: nil, optional: true],
 externalusername: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
