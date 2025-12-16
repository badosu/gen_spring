# codegen: do not edit
defmodule GenSpring.Protocol.Requests.OPENBATTLE do
  @moduledoc """
  Sent to a client who previously sent an 
   command,
        if the client's request to open a new battle has been approved. 
  	  

  	  Note that the corresponding 
   command is sent 
   this command is used to reflect the successful 
   command back to the client.
  	  

        After sending this command, the server will send a 
   (to notify the founding client that they have joined their own battle) followed by a 
  .
  """

  words = [battleid: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
