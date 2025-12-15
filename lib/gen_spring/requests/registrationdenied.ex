# codegen: do not edit
defmodule GenSpring.Requests.Registrationdenied do
  @moduledoc """
  Sent in response to a 
   command,
        if registration has been refused.
  """

  words = []
  sentences = [reason: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
