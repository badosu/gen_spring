# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CLIENTSFROM do
  @moduledoc """
  Sent by the server to a (non-bridged) client who just joined a channel.
  """

  words = [chan: [description: nil, optional: false], bridge: [description: nil, optional: false]]
  sentences = [clients: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
