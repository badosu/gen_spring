# codegen: do not edit
defmodule GenSpring.Protocol.Requests.RENAMEACCOUNT do
  @moduledoc """
  Will rename the current account name to newUsername.
        The user has to be logged in for this to work.
        After the server renames the account, it will disconnect the client.
  """

  words = [newusername: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
