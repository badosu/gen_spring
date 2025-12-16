# codegen: do not edit
defmodule GenSpring.Protocol.Requests.MOTD do
  @moduledoc """
  Sent by the server after 
  .
         The server may send multiple MOTD commands, each MOTD corresponds to one line of the current welcome message.
  """

  words = []
  sentences = [message: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
