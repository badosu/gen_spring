# codegen: do not edit
defmodule GenSpring.Requests.Logininfoend do
  @moduledoc """
  Sent by the server, indicating that it has finished sending the login info, completing the sequence initiated by
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
