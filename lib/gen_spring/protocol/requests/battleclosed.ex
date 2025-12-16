# codegen: do not edit
defmodule GenSpring.Protocol.Requests.BATTLECLOSED do
  @moduledoc """
  Sent to all users to notify that a battle has been closed.
  """

  words = [battleid: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
