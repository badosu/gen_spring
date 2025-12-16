# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOINBATTLEACCEPT do
  @moduledoc """
  Sent by a battle host, in response to a 
   command,
        instructing the server to allow the user to join their battle.
  """

  words = [username: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
