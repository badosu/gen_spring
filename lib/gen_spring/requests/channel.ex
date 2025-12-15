# codegen: do not edit
defmodule GenSpring.Requests.Channel do
  @moduledoc """
  Sent by the server to a client who requested the channels list
      via the 
   command.
      A series of these commands will be sent to the client,
      one for each open channel.
      A series of CHANNEL commands is followed by the 
   command.
  """

  words = [channame: [description: nil, optional: true],
 usercount: [description: nil, optional: true]]
  sentences = [topic: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
