# codegen: do not edit
defmodule GenSpring.Requests.Changeemailrequestaccepted do
  @moduledoc """
  Notifies that a verification code was sent, in response to 
  .
  		
  
  		No response is required from the client, although a 
   command would normally be sent once the user has supplied their verification code.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
