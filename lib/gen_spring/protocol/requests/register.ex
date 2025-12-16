# codegen: do not edit
defmodule GenSpring.Protocol.Requests.REGISTER do
  @moduledoc """
  The client sends this command when trying to register a new account.
        Note that the client must not already be logged in,
        or else the server will deny his request.
  	  

  	  

  	  The username and password are given sanity/uniqueness checks, and these primarily determine the servers response. If email verification is enabled, and no valid email address is provided, the server will deny the registration.
  """

  words = [
    username: [description: nil, optional: false],
    password: [description: nil, optional: false],
    email: [description: nil, optional: true]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
