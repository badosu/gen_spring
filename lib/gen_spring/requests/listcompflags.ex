# codegen: do not edit
defmodule GenSpring.Requests.Listcompflags do
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
