# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CONFIRMAGREEMENT do
  @moduledoc """
  Confirm that the user agreed to the user agreement, and supply an email verification code (if necessary).
  """

  words = [verificationcode: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
