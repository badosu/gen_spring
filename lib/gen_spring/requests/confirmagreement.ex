# codegen: do not edit
defmodule GenSpring.Requests.Confirmagreement do
  @moduledoc """
  Confirm that the user agreed to the user agreement, and supply an email verification code (if necessary).
  """

  words = [verificationcode: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
