# codegen: do not edit
defmodule GenSpring.Requests.Clientipport do
  @moduledoc """
  Sent to the battle's host, notifying him about another client's IP address
        and his public UDP source port.
  """

  words = [username: [description: nil, optional: true],
 ip: [description: nil, optional: true],
 port: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
