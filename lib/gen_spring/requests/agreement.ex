# codegen: do not edit
defmodule GenSpring.Requests.Agreement do
  @moduledoc """
  Sent by the server upon receiving a 
   command,
        if the client has not yet agreed to the server's "terms-of-use".
        The server may send multiple AGREEMENT commands, 
        each of corresponds to a new line in the agreement text,
        finishing with an 
   command.
        The client should send 
  
        and then resend the 
   command,
        or disconnect from the server if he has chosen to refuse the agreement.
  """

  words = []
  sentences = [agreement: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
