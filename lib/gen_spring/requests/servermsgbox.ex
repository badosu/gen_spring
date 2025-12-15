# codegen: do not edit
defmodule GenSpring.Requests.Servermsgbox do
  @moduledoc """
  The lobby client program should display this message to the user in an invasive way, which requires response from the user (for example, in a dialogue box with an OK button).
  """

  words = []
  sentences = [message: [description: nil, optional: true],
 url: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
