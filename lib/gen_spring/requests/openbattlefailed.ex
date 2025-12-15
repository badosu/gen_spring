# codegen: do not edit
defmodule GenSpring.Requests.Openbattlefailed do
  @moduledoc """
  Informs a client that tried to open a battle that their request has been rejected.
  """

  words = []
  sentences = [reason: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
