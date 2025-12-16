# codegen: do not edit
defmodule GenSpring.Protocol.Requests.RESENDVERIFICATIONACCEPTED do
  @moduledoc """
  Notifies that a verification code was re-sent, in response to 
  .
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
