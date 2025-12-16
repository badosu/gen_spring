# codegen: do not edit
defmodule GenSpring.Protocol.Requests.FORCETEAMNO do
  @moduledoc """
  Sent by the founder of a battle
        to change the team number of a user.
        The server will update the client's battle status automatically.
  """

  words = [
    username: [description: nil, optional: false],
    teamno: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
