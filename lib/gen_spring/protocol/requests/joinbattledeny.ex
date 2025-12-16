# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOINBATTLEDENY do
  @moduledoc """
  Sent by a battle host, in response to a 
   command,
        instructing the server to disallow the user to join their battle.
  """

  words = [username: [description: nil, optional: false]]
  sentences = [reason: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
