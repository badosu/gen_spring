# codegen: do not edit
defmodule GenSpring.Requests.Resetpasswordrequest do
  @moduledoc """
  Requests a verification code, to be sent to the email address of a user wishing to reset their password.
  """

  words = [email: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
