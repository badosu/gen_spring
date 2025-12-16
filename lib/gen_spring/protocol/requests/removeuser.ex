# codegen: do not edit
defmodule GenSpring.Protocol.Requests.REMOVEUSER do
  @moduledoc """
  Indicates that a user disconnected from the server.
        The client should remove this user from his clients list,
        which he must maintain while he is connected to the server.
  """

  words = [username: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
