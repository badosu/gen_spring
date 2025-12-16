# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CHANGEEMAILREQUESTDENIED do
  @moduledoc """
  Notifies that a verification code was not sent, in response to 
  .
  """

  words = []
  sentences = [errormsg: [description: nil, optional: false]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
