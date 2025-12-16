# codegen: do not edit
defmodule GenSpring.Protocol.Requests.RESENDVERIFICATIONDENIED do
  @moduledoc """
  Notifies that a verification code was not re-sent, in response to 
  .
  """

  words = []
  sentences = [errormsg: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
