# codegen: do not edit
defmodule GenSpring.Requests.Forceallyno do
  @moduledoc """
  Sent by the founder of a battle
        to change the ally team number of a user.
        The server will update the client's battle status automatically.
  """

  words = [username: [description: nil, optional: true],
 teamno: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
