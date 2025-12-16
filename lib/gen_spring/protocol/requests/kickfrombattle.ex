# codegen: do not edit
defmodule GenSpring.Protocol.Requests.KICKFROMBATTLE do
  @moduledoc """
  Sent by the server to notify the battle host that the named user should be kicked from the battle in progress.
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
