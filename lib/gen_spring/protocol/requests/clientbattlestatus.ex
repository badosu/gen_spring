# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CLIENTBATTLESTATUS do
  @moduledoc """
  Sent by the server to users participating in a battle
        when one of the clients changes his battle status.
  """

  words = [
    username: [description: nil, optional: false],
    battlestatus: [description: nil, optional: false],
    teamcolor: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
