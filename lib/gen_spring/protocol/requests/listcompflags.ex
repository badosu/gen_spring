# codegen: do not edit
defmodule GenSpring.Protocol.Requests.LISTCOMPFLAGS do
  @moduledoc """
  A client may send this command after it has received 

        to query the server for supported comp-flags that may be specified on 
  .
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
