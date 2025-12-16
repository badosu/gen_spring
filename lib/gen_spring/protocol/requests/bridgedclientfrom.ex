# codegen: do not edit
defmodule GenSpring.Protocol.Requests.BRIDGEDCLIENTFROM do
  @moduledoc """
  Sent by the server in response to a successful 
   command.
  	  

  	  The server will use 'externalUser:location' as the username for the bridged client.
  """

  words = [
    location: [description: nil, optional: false],
    externalid: [description: nil, optional: false],
    externalusername: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
