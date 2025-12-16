# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CLIENTIPPORT do
  @moduledoc """
  Sent to the battle's host, notifying him about another client's IP address
        and his public UDP source port.
  """

  words = [
    username: [description: nil, optional: false],
    ip: [description: nil, optional: false],
    port: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
