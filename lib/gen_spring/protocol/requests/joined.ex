# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOINED do
  @moduledoc """
  Sent to all clients in a channel (except the new client)
        when a new user joins the channel.
  """

  words = [
    channame: [description: nil, optional: false],
    username: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
