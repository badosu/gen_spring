# codegen: do not edit
defmodule GenSpring.Protocol.Requests.RESETPASSWORDDENIED do
  @moduledoc """
  Notifies that the password could not be changed, in response to 
  .
  """

  words = []
  sentences = [errormsg: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
