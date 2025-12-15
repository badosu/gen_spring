# codegen: do not edit
defmodule GenSpring.Requests.Mybattlestatus do
  @moduledoc """
  Sent by a client to the server, telling him his battle status changed.
  """

  words = [battlestatus: [description: nil, optional: true],
 myteamcolor: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
