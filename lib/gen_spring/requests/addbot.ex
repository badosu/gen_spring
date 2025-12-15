# codegen: do not edit
defmodule GenSpring.Requests.Addbot do
  @moduledoc """
  Indicates that a client has added a bot to the battle.
  """

  words = [battleid: [description: nil, optional: true],
 name: [description: nil, optional: true],
 owner: [description: nil, optional: true],
 battlestatus: [description: nil, optional: true],
 teamcolor: [description: nil, optional: true]]
  sentences = [ai_dll: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
