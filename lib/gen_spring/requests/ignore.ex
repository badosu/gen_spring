# codegen: do not edit
defmodule GenSpring.Requests.Ignore do
  @moduledoc """
  Tells the client that the user has been ignored (usually as a result of the IGNORE command sent by the client, but other sources are also possible).
          Also see the 
   command.
          This command uses named arguments, see "Named Arguments" chapter of the Intro section.
  """

  words = [username_value: [description: nil, optional: true]]
  sentences = [reason_value: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
