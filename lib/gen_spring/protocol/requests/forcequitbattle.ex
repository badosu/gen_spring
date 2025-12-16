# codegen: do not edit
defmodule GenSpring.Protocol.Requests.FORCEQUITBATTLE do
  @moduledoc """
  Sent to a client that was kicked from their current battle by the battle founder.
        

  	  The client does not need to send 
  ,
        as removal has already been done by the server.
        The only purpose of this command
        is to notify the client that they were kicked.
        (The client will also recieve a corresponding 
   notification.)
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
