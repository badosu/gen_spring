# codegen: do not edit
defmodule GenSpring.Protocol.Requests.UDPSOURCEPORT do
  @moduledoc """
  Sent as a response to a client's UDP packet
        (used with "hole punching" NAT traversal technique).
  """

  words = [port: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
