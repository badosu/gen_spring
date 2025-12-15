# codegen: do not edit
defmodule GenSpring.Requests.Changeemail do
  @moduledoc """
  Asks the server to change the email address associated to the client. See also 
  , which would typically be called first.
  """

  words = [newemail: [description: nil, optional: true],
 verificationcode: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
