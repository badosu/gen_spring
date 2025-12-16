# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CHANGEPASSWORD do
  @moduledoc """
  Will change the password of the users's account.
  """

  words = [
    oldpassword: [description: nil, optional: false],
    newpassword: [description: nil, optional: false]
  ]

  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
