defmodule SpringCodegen.Param do
  @moduledoc """
  Represents a LSP request
  """

  use TypedStruct

  typedstruct do
    field(:description, String.t())
    field(:name, String.t())
    field(:required, boolean())
    field(:kind, :word | :sentence)
  end

  def new(request) do
    %__MODULE__{
      name: request[:name],
      description: request[:description],
      required: request[:required],
      kind: String.to_atom(request[:kind])
    }
  end
end
