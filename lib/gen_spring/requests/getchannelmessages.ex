# codegen: do not edit
defmodule GenSpring.Requests.Getchannelmessages do
  @moduledoc """
  Sent by a client requesting the history of a channel, since the lastID.
  """

  words = [channame: [description: nil, optional: true],
 lastid: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
