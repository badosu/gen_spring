# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SAIDPRIVATEEX do
  @moduledoc """
  Sends a private message in "/me" IRC style on to its intended recipient.
  """

  words = [username: [description: nil, optional: false]]
  sentences = [message: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
