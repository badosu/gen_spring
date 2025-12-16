# codegen: do not edit
defmodule GenSpring.Protocol.Requests.OPENBATTLEFAILED do
  @moduledoc """
  Informs a client that tried to open a battle that their request has been rejected.
  """

  words = []
  sentences = [reason: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
