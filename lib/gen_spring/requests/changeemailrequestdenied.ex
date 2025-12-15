# codegen: do not edit
defmodule GenSpring.Requests.Changeemailrequestdenied do
  @moduledoc """
  Notifies that a verification code was not sent, in response to 
  .
  """

  words = []
  sentences = [errormsg: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
