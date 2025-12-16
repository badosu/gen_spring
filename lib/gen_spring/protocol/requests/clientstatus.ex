# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CLIENTSTATUS do
  @moduledoc """
  Sent by the server to all registered clients,
        indicating that a client's status changed.
        Note that client's status is considered 0 if not indicated otherwise
        (for example, when you login,
        the server sends only statuses of those clients whose statuses differ from 0,
        to save bandwidth).
  """

  words = [
    username: [description: nil, optional: false],
    status: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
