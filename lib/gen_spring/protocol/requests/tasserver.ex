# codegen: do not edit
defmodule GenSpring.Protocol.Requests.TASSERVER do
  @moduledoc """
  This is the first message (i.e. "greeting message") that a client receives
        upon connecting to the server.
  """

  words = [
    protocolversion: [description: nil, optional: false],
    springversion: [description: nil, optional: false],
    udpport: [description: nil, optional: false],
    servermode: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
