# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOINBATTLE do
  @moduledoc """
  Notifies a client that their request to 
   was successful, and that they have just joined the battle.
        

  	  Clients in the battle will be notified of the new user via 
  .
  	  
        
  	  Next, the server will send a series of commands to the newly joined client, which might include 
  , 
  , 
  , 
   and so on, 
  	  along with multiple 
  , in order to describe the current state of the battle to the joining client.
  	  

  	  If the battle has natType>0, the server will also send the clients IP port to the host, via the 
   command.
  """

  words = [
    battleid: [description: nil, optional: false],
    hashcode: [description: nil, optional: false],
    channelname: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
