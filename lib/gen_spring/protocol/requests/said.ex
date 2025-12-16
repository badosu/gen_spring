# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SAID do
  @moduledoc """
  Sent to all clients participating in a specific channel
        when one of the clients sent a chat message to it
        (including the author of the message).
  """

  words = [
    channame: [description: nil, optional: false],
    username: [description: nil, optional: false]
  ]

  sentences = [message: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
