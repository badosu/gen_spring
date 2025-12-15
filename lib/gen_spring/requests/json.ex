# codegen: do not edit
defmodule GenSpring.Requests.Json do
  @moduledoc """
  A command used to send information to clients in JSON format. (Currently rarely used.)
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
