# codegen: do not edit
defmodule GenSpring.Requests.Saidprivate do
  @moduledoc """
  Sends a private message on to its intended recipient.
  """

  words = [username: [description: nil, optional: true]]
  sentences = [message: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
