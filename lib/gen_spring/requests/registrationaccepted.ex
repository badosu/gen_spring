# codegen: do not edit
defmodule GenSpring.Requests.Registrationaccepted do
  @moduledoc """
  Sent in response to a 
   command,
        if registration has been accepted. 
  	  
  
  	  If email verification is enabled, sending of this command notifies that the server has sent a verification code to the users email address. This verification code is expected back from the client in 
  
        
  
  	  Upon reciept of this command, a lobby client would normally be expected to reply with a 
   attempt (but this is not a requirement of the protocol).
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
