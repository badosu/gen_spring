# codegen: do not edit
defmodule GenSpring.Requests.Joined do
  @moduledoc """
  Sent to all clients in a channel (except the new client)
        when a new user joins the channel.
  """

  words = [channame: [description: nil, optional: true],
 username: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
