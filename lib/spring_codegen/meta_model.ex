defmodule SpringCodegen.MetaModel do
  @moduledoc """
  The actual meta model.
  """

  use TypedStruct

  typedstruct enforce: true do
    field(:requests, list(Request.t()))
    field(:version, String.t())
  end

  def new(decoded_json) do
    requests =
      decoded_json
      |> get_in(["ProtocolDescription", "CommandList", "Command"])
      |> Enum.map(&map_request/1)

    %__MODULE__{
      requests: requests,
      version: "0.38"
    }
  end

  def fetch!(path) do
    read_priv!(path)
    |> Jason.decode!()
    |> new()
  end

  defp read_priv!(path) do
    # :code.priv_dir(:gen_spring)
    "priv/spring_codegen"
    |> Path.join(path)
    |> File.read!()
  end

  defp map_request(command) do
    examples = command |> get_in(["Examples", "Example"]) |> List.wrap()

    arguments =
      command
      |> get_in(["Arguments", "Argument"])
      |> List.wrap()
      |> Enum.map(&map_argument/1)

    arguments = for(argument <- arguments, do: SpringCodegen.Param.new(argument))
    {sentences, words} = Enum.split_with(arguments, & &1.sentence)

    description =
      case command["Description"] do
        description when is_binary(description) -> description
        %{"__text" => description} -> description
      end

    fields = %{
      source: command["_Source"],
      method: command["_Name"],
      description: description,
      examples: examples,
      sentences: sentences,
      words: words
    }

    struct(SpringCodegen.Request, fields)
  end

  defp map_argument(argument) do
    %{
      name: argument["_Name"],
      required: Map.fetch!(argument, "_Optional") == "no",
      sentence: Map.fetch!(argument, "_Sentence") == "yes"
    }
  end
end
