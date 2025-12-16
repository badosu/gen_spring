# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CHANGEEMAIL do
  @moduledoc """
  Asks the server to change the email address associated to the client. See also 
  , which would typically be called first.
  """

  words = [
    newemail: [description: nil, optional: false],
    verificationcode: [description: nil, optional: true]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
