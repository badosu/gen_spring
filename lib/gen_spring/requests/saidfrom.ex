# codegen: do not edit
defmodule GenSpring.Requests.Saidfrom do
  @moduledoc """
  Sent by the server in response to a successful 
   command.
  """

  words = [chan: [description: nil, optional: true],
 username: [description: nil, optional: true]]
  sentences = [message: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
