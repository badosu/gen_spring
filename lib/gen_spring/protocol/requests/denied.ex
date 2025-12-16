# codegen: do not edit
defmodule GenSpring.Protocol.Requests.DENIED do
  @moduledoc """
  Sent as a response to a failed 
   command.
  """

  words = []
  sentences = [reason: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
