# codegen: do not edit
defmodule GenSpring.Requests.Unbridgedclientfrom do
  @moduledoc """
  Sent by the server in response to a successful 
   command.
  """

  words = [location: [description: nil, optional: true],
 externalid: [description: nil, optional: true],
 externalusername: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
