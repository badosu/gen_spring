# codegen: do not edit
defmodule GenSpring.Protocol.Requests.ENABLEALLUNITS do
  @moduledoc """
  Sent by the server to all clients in a battle,
        telling them that the disabled units list has been cleared.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
