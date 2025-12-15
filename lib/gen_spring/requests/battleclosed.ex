# codegen: do not edit
defmodule GenSpring.Requests.Battleclosed do
  @moduledoc """
  Sent to all users to notify that a battle has been closed.
  """

  words = [battleid: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
