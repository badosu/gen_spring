# codegen: do not edit
defmodule GenSpring.Requests.Leftbattle do
  @moduledoc """
  Sent by the server to all users when a client left a battle
        (or got disconnected from the server).
  """

  words = [battleid: [description: nil, optional: true],
 username: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
