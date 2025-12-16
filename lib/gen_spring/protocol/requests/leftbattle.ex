# codegen: do not edit
defmodule GenSpring.Protocol.Requests.LEFTBATTLE do
  @moduledoc """
  Sent by the server to all users when a client left a battle
        (or got disconnected from the server).
  """

  words = [
    battleid: [description: nil, optional: false],
    username: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
