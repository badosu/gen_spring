# codegen: do not edit
defmodule GenSpring.Protocol.Requests.LOGIN do
  @moduledoc """
  Sent by a client asking to log on to the server.
  	  

        Note: if the client has not yet confirmed the user agreement,
        then server will send the 
   to the client as a response to this command.
  	  In this case the response to 
   will be delayed until after 
  .
        

        Also see 
   command.
  """

  words = [
    username: [description: nil, optional: false],
    password: [description: nil, optional: false],
    cpu: [description: nil, optional: false],
    localip: [description: nil, optional: false],
    userid: [description: nil, optional: true]
  ]

  sentences = [
    lobby_name_and_version: [description: nil, optional: false],
    compflags: [description: nil, optional: true]
  ]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
