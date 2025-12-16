# codegen: do not edit
defmodule GenSpring.Protocol.Requests.RING do
  @moduledoc """
  Sent to notify a client that another user requested that a "ring" sound be played to them.
  """

  words = [username: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
