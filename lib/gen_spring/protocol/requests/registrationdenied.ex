# codegen: do not edit
defmodule GenSpring.Protocol.Requests.REGISTRATIONDENIED do
  @moduledoc """
  Sent in response to a 
   command,
        if registration has been refused.
  """

  words = []
  sentences = [reason: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
