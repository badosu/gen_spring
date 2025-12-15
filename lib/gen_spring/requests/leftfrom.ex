# codegen: do not edit
defmodule GenSpring.Requests.Leftfrom do
  @moduledoc """
  Sent by the server in response to a successful 
   command.
  """

  words = [chan: [description: nil, optional: true],
 username: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
