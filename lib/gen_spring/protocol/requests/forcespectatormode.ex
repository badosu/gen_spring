# codegen: do not edit
defmodule GenSpring.Protocol.Requests.FORCESPECTATORMODE do
  @moduledoc """
  Sent by the founder of a battle
        to force a given user to become a spectator.
        The server will update the client's battle status automatically.
  """

  words = [username: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
