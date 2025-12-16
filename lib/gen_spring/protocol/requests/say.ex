# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SAY do
  @moduledoc """
  Send a chat message to a specific channel.
        The client has to join the channel first,
        to be allowed to use this command.
  """

  words = [channame: [description: nil, optional: false]]
  sentences = [message: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
