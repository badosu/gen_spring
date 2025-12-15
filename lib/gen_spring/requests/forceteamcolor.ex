# codegen: do not edit
defmodule GenSpring.Requests.Forceteamcolor do
  @moduledoc """
  Sent by the founder of a battle
        to change the team colour of a team.
        The server will update the client's battle status automatically.
  """

  words = [username: [description: nil, optional: true],
 color: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
