# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOINEDBATTLE do
  @moduledoc """
  Sent by the server to all clients when a new client joins the battle. 

  	  The server does not send this command for a host, when that host opens its own battle.
  """

  words = [
    battleid: [description: nil, optional: false],
    username: [description: nil, optional: false],
    scriptpassword: [description: nil, optional: true]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
