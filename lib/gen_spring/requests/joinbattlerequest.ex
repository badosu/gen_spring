# codegen: do not edit
defmodule GenSpring.Requests.Joinbattlerequest do
  @moduledoc """
  Sent by the server to a battle host, each time a client requests to join his battle.
  """

  words = [username: [description: nil, optional: true],
 ip: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
