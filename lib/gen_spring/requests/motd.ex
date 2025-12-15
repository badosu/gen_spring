# codegen: do not edit
defmodule GenSpring.Requests.Motd do
  @moduledoc """
  Sent by the server after 
  .
         The server may send multiple MOTD commands, each MOTD corresponds to one line of the current welcome message.
  """

  words = []
  sentences = [message: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
