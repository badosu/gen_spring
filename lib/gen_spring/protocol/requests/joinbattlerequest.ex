# codegen: do not edit
defmodule GenSpring.Protocol.Requests.JOINBATTLEREQUEST do
  @moduledoc """
  Sent by the server to a battle host, each time a client requests to join his battle.
  """

  words = [username: [description: nil, optional: false], ip: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
