# codegen: do not edit
defmodule GenSpring.Requests.Resetpassword do
  @moduledoc """
  Asks the server to change the password associated to the client. See also 
  , which would typically be called first.
  """

  words = [email: [description: nil, optional: true],
 verificationcode: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
