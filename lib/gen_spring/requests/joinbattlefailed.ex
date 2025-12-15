# codegen: do not edit
defmodule GenSpring.Requests.Joinbattlefailed do
  @moduledoc """
  Notifies a client that their request to 
   was denied.
  """

  words = []
  sentences = [reason: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
