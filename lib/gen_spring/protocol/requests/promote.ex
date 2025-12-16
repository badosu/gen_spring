# codegen: do not edit
defmodule GenSpring.Protocol.Requests.PROMOTE do
  @moduledoc """
  This command posts a message in particular channels, calling for players. It is currently the (only) test case for a client command used JSON format.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
