# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CHANNEL do
  @moduledoc """
  Sent by the server to a client who requested the channels list
      via the 
   command.
      A series of these commands will be sent to the client,
      one for each open channel.
      A series of CHANNEL commands is followed by the 
   command.
  """

  words = [
    channame: [description: nil, optional: false],
    usercount: [description: nil, optional: false]
  ]

  sentences = [topic: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
