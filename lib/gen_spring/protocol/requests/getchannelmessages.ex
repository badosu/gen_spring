# codegen: do not edit
defmodule GenSpring.Protocol.Requests.GETCHANNELMESSAGES do
  @moduledoc """
  Sent by a client requesting the history of a channel, since the lastID.
  """

  words = [
    channame: [description: nil, optional: false],
    lastid: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
