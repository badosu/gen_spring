# codegen: do not edit
defmodule GenSpring.Requests.Ignorelist do
  @moduledoc """
  Multiple commands of this kind may be sent after a 
   command (or none, if the ignore list is empty).
          This command uses named arguments, see "Named Arguments" chapter of the Intro section.
  """

  words = [username_value: [description: nil, optional: true]]
  sentences = [reason_value: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
