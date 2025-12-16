# codegen: do not edit
defmodule GenSpring.Protocol.Requests.REMOVEBOT do
  @moduledoc """
  Indicates that a bot has been removed from the battle.
  """

  words = [
    battleid: [description: nil, optional: false],
    name: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
