# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SERVERMSG do
  @moduledoc """
  A general purpose message sent by the server.
        The lobby client program should display this message to the user in a non-invasive way, but clearly visible to the user 
  	  (for example, as a SAYEX-style message from the server, printed into all the users chat panels).
  """

  words = []
  sentences = [message: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
