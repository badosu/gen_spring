# codegen: do not edit
defmodule GenSpring.Protocol.Requests.ADDBOT do
  @moduledoc """
  Indicates that a client has added a bot to the battle.
  """

  words = [
    battleid: [description: nil, optional: false],
    name: [description: nil, optional: false],
    owner: [description: nil, optional: false],
    battlestatus: [description: nil, optional: false],
    teamcolor: [description: nil, optional: false]
  ]

  sentences = [ai_dll: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
