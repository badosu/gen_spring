# codegen: do not edit
defmodule GenSpring.Requests.Channels do
  @moduledoc """
  Sent by a client when requesting the list of all channels on the server
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
