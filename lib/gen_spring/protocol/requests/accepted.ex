# codegen: do not edit
defmodule GenSpring.Protocol.Requests.ACCEPTED do
  @moduledoc """
  Sent as a response to the 
   command, if it succeeded.
        Next, the server will send much info about clients and battles:
        

  	  Finally, 
        it will send a 
   command
        indicating that it has finished sending all this info. Note that, except for this final command, the commands/info listed above may be sent to the client in any order.
  """

  words = [username: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
