# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SAYFROM do
  @moduledoc """
  Sent by a bridge bot to notify that a bridged user spoke into a channel.
  """

  words = [
    chan: [description: nil, optional: false],
    location: [description: nil, optional: false],
    externalid: [description: nil, optional: false],
    message: [description: nil, optional: true]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
