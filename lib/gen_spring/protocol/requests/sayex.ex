# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SAYEX do
  @moduledoc """
  Sent by any client requesting to say something in a channel in "/me" IRC style.
        (The 
   command is used for normal chat messages.)
  """

  words = [channame: [description: nil, optional: false]]
  sentences = [message: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
