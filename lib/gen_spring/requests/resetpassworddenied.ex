# codegen: do not edit
defmodule GenSpring.Requests.Resetpassworddenied do
  @moduledoc """
  Notifies that the password could not be changed, in response to 
  .
  """

  words = []
  sentences = [errormsg: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
