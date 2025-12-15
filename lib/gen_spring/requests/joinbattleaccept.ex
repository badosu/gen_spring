# codegen: do not edit
defmodule GenSpring.Requests.Joinbattleaccept do
  @moduledoc """
  Sent by a battle host, in response to a 
   command,
        instructing the server to allow the user to join their battle.
  """

  words = [username: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
