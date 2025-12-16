# codegen: do not edit
defmodule GenSpring.Protocol.Requests.REQUESTBATTLESTATUS do
  @moduledoc """
  Sent by the server to a user which just opened a battle or joined one.
        Sent after all 

        commands for all clients have been sent.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
