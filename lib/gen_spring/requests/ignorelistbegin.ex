# codegen: do not edit
defmodule GenSpring.Requests.Ignorelistbegin do
  @moduledoc """
  Sent by the server when sending the ignore list to the client.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
