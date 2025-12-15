# codegen: do not edit
defmodule GenSpring.Requests.Leavefrom do
  @moduledoc """
  Sent by a bridge bot requesting to remove a bridged client from a channel.
  """

  words = [chan: [description: nil, optional: true],
 location: [description: nil, optional: true],
 externalid: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
