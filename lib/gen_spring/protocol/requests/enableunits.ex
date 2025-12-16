# codegen: do not edit
defmodule GenSpring.Protocol.Requests.ENABLEUNITS do
  @moduledoc """
  Sent by the server to all clients in a battle,
        telling them that some units have been added to enabled units list.
        Also see the 
   command.
  """

  words = [
    unitname1: [description: nil, optional: false],
    unitname2: [description: nil, optional: true],
    variadic: [description: nil, optional: true]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
