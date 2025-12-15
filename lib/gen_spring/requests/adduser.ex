# codegen: do not edit
defmodule GenSpring.Requests.Adduser do
  @moduledoc """
  Tells the client that a new user joined a server.
        The client should add this user to his clients list,
        which he must maintain while he is connected to the server.
  """

  words = [username: [description: nil, optional: true],
 country: [description: nil, optional: true],
 cpu: [description: nil, optional: true],
 userid: [description: nil, optional: true]]
  sentences = [lobbyid: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
