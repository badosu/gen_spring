# codegen: do not edit
defmodule GenSpring.Protocol.Requests.FAILED do
  @moduledoc """
  A command used to notify that a command sent to the server has either failed, been denied, or otherwise cannot be completed. 
  		

  		This normally is used as a generic error command, to inform lobby/client developers that they have not used the protocol correctly.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
