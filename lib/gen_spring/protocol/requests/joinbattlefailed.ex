# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOINBATTLEFAILED do
  @moduledoc """
  Notifies a client that their request to 
   was denied.
  """

  words = []
  sentences = [reason: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
