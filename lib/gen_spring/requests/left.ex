# codegen: do not edit
defmodule GenSpring.Requests.Left do
  @moduledoc """
  Sent by the server to inform a client, present in a channel, that another user or himself has left that channel.
  """

  words = [channame: [description: nil, optional: true],
 username: [description: nil, optional: true]]
  sentences = [reason: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
