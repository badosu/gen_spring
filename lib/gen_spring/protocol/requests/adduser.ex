# codegen: do not edit
defmodule GenSpring.Protocol.Requests.ADDUSER do
  @moduledoc """
  Tells the client that a new user joined a server.
        The client should add this user to his clients list,
        which he must maintain while he is connected to the server.
  """

  words = [
    username: [description: nil, optional: false],
    country: [description: nil, optional: false],
    cpu: [description: nil, optional: false],
    userid: [description: nil, optional: false]
  ]

  sentences = [lobbyid: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
