# codegen: do not edit
defmodule GenSpring.Requests.Updatebattleinfo do
  @moduledoc """
  Sent by the founder of the battle,
        telling the server that some of the "external" parameters of the battle changed.
  """

  words = [spectatorcount: [description: nil, optional: true],
 locked: [description: nil, optional: true],
 maphash: [description: nil, optional: true]]
  sentences = [mapname: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
