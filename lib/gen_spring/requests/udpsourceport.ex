# codegen: do not edit
defmodule GenSpring.Requests.Udpsourceport do
  @moduledoc """
  Sent as a response to a client's UDP packet
        (used with "hole punching" NAT traversal technique).
  """

  words = [port: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
