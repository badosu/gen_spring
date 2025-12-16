# codegen: do not edit
defmodule GenSpring.Protocol.Requests.HANDICAP do
  @moduledoc """
  Sent by the founder of the battle when changing a user's handicap value
        (which is part of that users battle status).
        

  	  Only the founder can change other users handicap values, and that requests from non-founder users will be ignored.
  """

  words = [
    username: [description: nil, optional: false],
    value: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
