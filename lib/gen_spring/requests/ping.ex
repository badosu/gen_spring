# codegen: do not edit
defmodule GenSpring.Requests.Ping do
  @moduledoc """
  Requests a 
   back from the server. 
  	  
  
  	  Clients should send 
   once every 30 seconds, if no other data is being sent to the server. For details, see the notes above on keep-alive signals.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
