# codegen: do not edit
defmodule GenSpring.Requests.Saidprivateex do
  @moduledoc """
  Sends a private message in "/me" IRC style on to its intended recipient.
  """

  words = [username: [description: nil, optional: true]]
  sentences = [message: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
