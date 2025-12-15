# codegen: do not edit
defmodule GenSpring.Requests.Clientsfrom do
  @moduledoc """
  Sent by the server to a (non-bridged) client who just joined a channel.
  """

  words = [chan: [description: nil, optional: true],
 bridge: [description: nil, optional: true]]
  sentences = [clients: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
