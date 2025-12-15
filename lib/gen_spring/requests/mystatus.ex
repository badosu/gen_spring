# codegen: do not edit
defmodule GenSpring.Requests.Mystatus do
  @moduledoc """
  Sent by a client to inform the server about his changed status.
        
  
  	  Note: To tell out if a battle is "in-game", a client must check the in-game status of the host.
  """

  words = [status: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
