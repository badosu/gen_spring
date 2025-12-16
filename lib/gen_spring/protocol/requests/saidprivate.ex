# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SAIDPRIVATE do
  @moduledoc """
  Sends a private message on to its intended recipient.
  """

  words = [username: [description: nil, optional: false]]
  sentences = [message: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
