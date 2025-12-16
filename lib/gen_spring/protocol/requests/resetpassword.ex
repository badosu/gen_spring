# codegen: do not edit
defmodule GenSpring.Protocol.Requests.RESETPASSWORD do
  @moduledoc """
  Asks the server to change the password associated to the client. See also 
  , which would typically be called first.
  """

  words = [
    email: [description: nil, optional: false],
    verificationcode: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
