# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CHANGEEMAILDENIED do
  @moduledoc """
  Notifies that the email address could not be changed, in response to 
  .
  """

  words = []
  sentences = [errormsg: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
