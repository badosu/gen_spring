# codegen: do not edit
defmodule GenSpring.Requests.Changepassword do
  @moduledoc """
  Will change the password of the users's account.
  """

  words = [oldpassword: [description: nil, optional: true],
 newpassword: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
