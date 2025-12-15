# codegen: do not edit
defmodule GenSpring.Requests.Kickfrombattle do
  @moduledoc """
  Sent by the server to notify the battle host that the named user should be kicked from the battle in progress.
  """

  words = [battleid: [description: nil, optional: true],
 username: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
