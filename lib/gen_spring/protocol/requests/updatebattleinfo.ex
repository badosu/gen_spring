# codegen: do not edit
defmodule GenSpring.Protocol.Requests.UPDATEBATTLEINFO do
  @moduledoc """
  Sent by the founder of the battle,
        telling the server that some of the "external" parameters of the battle changed.
  """

  words = [
    spectatorcount: [description: nil, optional: false],
    locked: [description: nil, optional: false],
    maphash: [description: nil, optional: false]
  ]

  sentences = [mapname: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
