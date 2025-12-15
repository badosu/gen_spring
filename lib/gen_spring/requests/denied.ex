# codegen: do not edit
defmodule GenSpring.Requests.Denied do
  @moduledoc """
  Sent as a response to a failed 
   command.
  """

  words = []
  sentences = [reason: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
