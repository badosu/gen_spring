# codegen: do not edit
defmodule GenSpring.Requests.Sayfrom do
  @moduledoc """
  Sent by a bridge bot to notify that a bridged user spoke into a channel.
  """

  words = [chan: [description: nil, optional: true],
 location: [description: nil, optional: true],
 externalid: [description: nil, optional: true],
 message: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
