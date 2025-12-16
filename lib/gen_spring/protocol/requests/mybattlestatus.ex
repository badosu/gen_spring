# codegen: do not edit
defmodule GenSpring.Protocol.Requests.MYBATTLESTATUS do
  @moduledoc """
  Sent by a client to the server, telling him his battle status changed.
  """

  words = [
    battlestatus: [description: nil, optional: false],
    myteamcolor: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
