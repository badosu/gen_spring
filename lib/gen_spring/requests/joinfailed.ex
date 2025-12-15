# codegen: do not edit
defmodule GenSpring.Requests.Joinfailed do
  @moduledoc """
  Sent if joining a channel failed for some reason.
  """

  words = [channame: [description: nil, optional: true]]
  sentences = [reason: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
