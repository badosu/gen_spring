# codegen: do not edit
defmodule GenSpring.Protocol.Requests.RESENDVERIFICATION do
  @moduledoc """
  Request that an active verification code to be re-sent.
  """

  words = [newemail: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
