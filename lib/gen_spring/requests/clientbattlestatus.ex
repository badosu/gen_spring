# codegen: do not edit
defmodule GenSpring.Requests.Clientbattlestatus do
  @moduledoc """
  Sent by the server to users participating in a battle
        when one of the clients changes his battle status.
  """

  words = [username: [description: nil, optional: true],
 battlestatus: [description: nil, optional: true],
 teamcolor: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
