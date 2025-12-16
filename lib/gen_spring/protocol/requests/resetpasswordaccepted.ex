# codegen: do not edit
defmodule GenSpring.Protocol.Requests.RESETPASSWORDACCEPTED do
  @moduledoc """
  Notifies that client that their password was changed, in response to 
  . The new password will be emailed to the client.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
