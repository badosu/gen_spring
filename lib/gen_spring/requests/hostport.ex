# codegen: do not edit
defmodule GenSpring.Requests.Hostport do
  @moduledoc """
  Sent by the server to all clients participating in the battle, except for the host, notifying them about the (possibly new) host port.
  """

  words = [port: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
