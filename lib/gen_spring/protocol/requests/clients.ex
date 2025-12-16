# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CLIENTS do
  @moduledoc """
  Sent to a client who just joined the channel. This command informs the client of the list of users present in the channel, including the client itself.
  	  

  	  This command is always sent (to a client joining a channel), and the list it conveys includes the newly joined client. 
  	  It is sent after all the 
   commands.
  	  Once 
   has been processed, the joining client has been informed of the full list of other clients and bridged clients currently present in the joined channel.
  """

  words = [channame: [description: nil, optional: false]]
  sentences = [clients: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
