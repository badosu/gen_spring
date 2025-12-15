# codegen: do not edit
defmodule GenSpring.Requests.Pong do
  @moduledoc """
  Sent as the response to a 
   command.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
