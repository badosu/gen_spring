# codegen: do not edit
defmodule GenSpring.Protocol.Requests.SERVERMSGBOX do
  @moduledoc """
  The lobby client program should display this message to the user in an invasive way, which requires response from the user (for example, in a dialogue box with an OK button).
  """

  words = []

  sentences = [
    message: [description: nil, optional: false],
    url: [description: nil, optional: true]
  ]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
