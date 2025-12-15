# codegen: do not edit
defmodule GenSpring.Requests.Ok do
  @moduledoc """
  Sent as the response to a 
   command. The client now can now start the tls connection. The server will send again the greeting
        
  .
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
