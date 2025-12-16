# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOINFAILED do
  @moduledoc """
  Sent if joining a channel failed for some reason.
  """

  words = [channame: [description: nil, optional: false]]
  sentences = [reason: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
