# codegen: do not edit
defmodule GenSpring.Requests.Addstartrect do
  @moduledoc """
  Sent by the server to clients participating in a battle (except for the host).
        See lobby client implementations and Spring docs for more info on this one.
        "left", "top", "right" and "bottom" refer to a virtual rectangle that is 200x200 in size,
        where coordinates should be in the interval [0, 200].
  """

  words = [allyno: [description: nil, optional: true],
 left: [description: nil, optional: true],
 top: [description: nil, optional: true],
 right: [description: nil, optional: true],
 bottom: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
