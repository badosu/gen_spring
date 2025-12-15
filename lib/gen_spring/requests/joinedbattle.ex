# codegen: do not edit
defmodule GenSpring.Requests.Joinedbattle do
  @moduledoc """
  Sent by the server to all clients when a new client joins the battle. 
  
  	  The server does not send this command for a host, when that host opens its own battle.
  """

  words = [battleid: [description: nil, optional: true],
 username: [description: nil, optional: true],
 scriptpassword: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
