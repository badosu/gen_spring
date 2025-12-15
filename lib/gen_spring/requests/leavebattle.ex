# codegen: do not edit
defmodule GenSpring.Requests.Leavebattle do
  @moduledoc """
  Sent by the client when he leaves a battle.
  	  
  
        When this command is by the founder of a battle, it notifies that the battle is now closed.
  """

  words = []
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
