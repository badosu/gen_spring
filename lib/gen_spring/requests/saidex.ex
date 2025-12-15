# codegen: do not edit
defmodule GenSpring.Requests.Saidex do
  @moduledoc """
  Sent by the server when a client said something
        using the 
   command.
  """

  words = [channame: [description: nil, optional: true],
 username: [description: nil, optional: true]]
  sentences = [message: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
