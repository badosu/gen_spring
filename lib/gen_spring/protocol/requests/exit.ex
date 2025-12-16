# codegen: do not edit
defmodule GenSpring.Protocol.Requests.EXIT do
  @moduledoc """
  Clients should send this as their last command before severing their connection to the server, to notify
        a clean and deliberate disconnect.
  """

  words = []
  sentences = [reason: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
