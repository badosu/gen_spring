# codegen: do not edit
defmodule GenSpring.Protocol.Requests.HOSTPORT do
  @moduledoc """
  Sent by the server to all clients participating in the battle, except for the host, notifying them about the (possibly new) host port.
  """

  words = [port: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
