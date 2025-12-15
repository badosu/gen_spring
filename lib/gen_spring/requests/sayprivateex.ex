# codegen: do not edit
defmodule GenSpring.Requests.Sayprivateex do
  @moduledoc """
  Sent to a client that just sent a 
   command.
        This notifies the client that the server sent the private message on to its intended recipient.
  """

  words = [username: [description: nil, optional: true]]
  sentences = [message: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
