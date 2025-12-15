# codegen: do not edit
defmodule GenSpring.Requests.Joinbattledeny do
  @moduledoc """
  Sent by a battle host, in response to a 
   command,
        instructing the server to disallow the user to join their battle.
  """

  words = [username: [description: nil, optional: true]]
  sentences = [reason: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
