# codegen: do not edit
defmodule GenSpring.Requests.Resendverification do
  @moduledoc """
  Request that an active verification code to be re-sent.
  """

  words = [newemail: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
