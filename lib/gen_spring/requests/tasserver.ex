# codegen: do not edit
defmodule GenSpring.Requests.Tasserver do
  @moduledoc """
  This is the first message (i.e. "greeting message") that a client receives
        upon connecting to the server.
  """

  words = [protocolversion: [description: nil, optional: true],
 springversion: [description: nil, optional: true],
 udpport: [description: nil, optional: true],
 servermode: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
