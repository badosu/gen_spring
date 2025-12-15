# codegen: do not edit
defmodule GenSpring.Requests.Said do
  @moduledoc """
  Sent to all clients participating in a specific channel
        when one of the clients sent a chat message to it
        (including the author of the message).
  """

  words = [channame: [description: nil, optional: true],
 username: [description: nil, optional: true]]
  sentences = [message: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
