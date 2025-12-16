# codegen: do not edit
defmodule GenSpring.Protocol.Requests.ADDSTARTRECT do
  @moduledoc """
  Sent by the server to clients participating in a battle (except for the host).
        See lobby client implementations and Spring docs for more info on this one.
        "left", "top", "right" and "bottom" refer to a virtual rectangle that is 200x200 in size,
        where coordinates should be in the interval [0, 200].
  """

  words = [
    allyno: [description: nil, optional: false],
    left: [description: nil, optional: false],
    top: [description: nil, optional: false],
    right: [description: nil, optional: false],
    bottom: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
