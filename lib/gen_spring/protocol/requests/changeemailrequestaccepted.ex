# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CHANGEEMAILREQUESTACCEPTED do
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
