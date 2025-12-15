# codegen: do not edit
defmodule GenSpring.Requests.Channeltopic do
  @moduledoc """
  A request to change a channel's topic, typically sent by a priviledged user.
  """

  words = [channame: [description: nil, optional: true],
 topic: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
