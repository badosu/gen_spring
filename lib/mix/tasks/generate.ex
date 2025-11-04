defmodule Mix.Tasks.Generate do
  @moduledoc "The hello mix task: `mix help hello`"
  use Mix.Task

  require Logger

  @shortdoc "Calls the Hello.say/0 function."
  def run(_) do
    SpringCodegen.generate()
  end
end
