# codegen: do not edit
defmodule GenSpring.Requests.Removestartrect do
  @moduledoc """
  Removing a start rectangle the for 'allyNo' ally team.
        Sent to clients participating in a battle (except for the host).
        Also see 
   command.
  """

  words = [allyno: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
