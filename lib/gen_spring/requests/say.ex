# codegen: do not edit
defmodule GenSpring.Requests.Say do
  @moduledoc """
  Send a chat message to a specific channel.
        The client has to join the channel first,
        to be allowed to use this command.
  """

  words = [channame: [description: nil, optional: true]]
  sentences = [message: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
