# codegen: do not edit
defmodule GenSpring.Requests.Endofchannels do
  @moduledoc """
  Sent to a client who previously requested the channel list,
        after a series of 
   commands (one for each channel).
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
