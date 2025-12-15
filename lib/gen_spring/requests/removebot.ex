# codegen: do not edit
defmodule GenSpring.Requests.Removebot do
  @moduledoc """
  Indicates that a bot has been removed from the battle.
  """

  words = [battleid: [description: nil, optional: true],
 name: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
