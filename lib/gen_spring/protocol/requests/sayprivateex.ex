# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SAYPRIVATEEX do
  @moduledoc """
  Sent to a client that just sent a 
   command.
        This notifies the client that the server sent the private message on to its intended recipient.
  """

  words = [username: [description: nil, optional: false]]
  sentences = [message: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
