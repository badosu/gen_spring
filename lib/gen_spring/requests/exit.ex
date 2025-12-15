# codegen: do not edit
defmodule GenSpring.Requests.Exit do
  @moduledoc """
  Clients should send this as their last command before severing their connection to the server, to notify
        a clean and deliberate disconnect.
  """

  words = []
  sentences = [reason: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
