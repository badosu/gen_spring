# codegen: do not edit
defmodule GenSpring.Requests.Leave do
  @moduledoc """
  Sent by a client when requesting to leave a channel.
        
  
  	  Note that when the client is disconnected, the client is automatically removed from all channels.
  """

  words = [channame: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
