# codegen: do not edit
defmodule GenSpring.Protocol.Requests.CHANGEEMAILREQUEST do
  @moduledoc """
  Requests a verification code, to be sent to a new email address that the user wishes to associate to their account.
  		

  		Even if email verification is disabled, it is intended that the client will call this before calling 
  .
  		If email verification is disabled, the response will be a 
  , containing a message informing the user that a blank verification code will be accepted.
  """

  words = [newemail: [description: nil, optional: false]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
