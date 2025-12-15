defmodule SpringCodegen.Param do
  @moduledoc """
  Represents a LSP request
  """

  use TypedStruct

  typedstruct do
    field(:description, String.t())
    field(:name, String.t())
    field(:required, boolean())
    field(:sentence, boolean())
  end

  def new(request) do
    %__MODULE__{
      name: request[:name],
      description: request[:description],
      required: request[:required],
      sentence: request[:sentence]
    }
  end

  defimpl Inspect, for: __MODULE__ do
    def inspect(param, _opts) do
      name =
        String.downcase(param.name)
        |> String.replace("=", "_")
        |> String.replace(" ", "_")
        |> String.replace("...", "variadic")
        |> Macro.underscore()

      required = param.required == nil or not param.required

      opts = [
        description: param.description,
        optional: not required
      ]

      "#{name}: #{inspect(opts)}"
    end
  end
end
