# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CHANNELTOPIC do
  @moduledoc """
  A request to change a channel's topic, typically sent by a priviledged user.
  """

  words = [
    channame: [description: nil, optional: false],
    topic: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
