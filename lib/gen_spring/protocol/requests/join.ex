# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOIN do
  @moduledoc """
  Sent to a client who has successfully 
  ed a channel. 
  	  The server will now send the client a 
   and a 
   command, which together give the list of users present in the channel.
  """

  words = [channame: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
