# codegen: do not edit
defmodule GenSpring.Requests.Sayex do
  @moduledoc """
  Sent by any client requesting to say something in a channel in "/me" IRC style.
        (The 
   command is used for normal chat messages.)
  """

  words = [channame: [description: nil, optional: true]]
  sentences = [message: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
