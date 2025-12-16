# codegen: do not edit
defmodule GenSpring.Protocol.Requests.IGNORELISTEND do
  @moduledoc """
  Sent by the server after it has finished sending the ignore list for a client.
          Also see the 
   and 
   commands.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
