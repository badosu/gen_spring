# codegen: do not edit
defmodule GenSpring.Requests.Joinfrom do
  @moduledoc """
  Send by a bridge bot requesting to join a bridged client to a channel.
  """

  words = [chan: [description: nil, optional: true],
 location: [description: nil, optional: true],
 externalid: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
