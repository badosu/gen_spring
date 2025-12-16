defmodule SpringCodegen.Request do
  @moduledoc """
  Represents a LSP request
  """

  use TypedStruct

  typedstruct do
    field(:method, String.t())
    field(:description, String.t())
    field(:words, list(Map.t()))
    field(:sentences, list(Map.t()))
    field(:source, :client | :server)
    field(:examples, list(String.t()))
  end

  def new(request) do
    %__MODULE__{
      method: request[:method],
      source: String.to_existing_atom(request[:source]),
      description: request[:description],
      words: request[:words],
      sentences: request[:sentences],
      examples: request[:examples]
    }
  end

  defimpl SpringCodegen.Codegen do
    require EEx

    def module_name(request) do
      "GenSpring.Protocol.Requests.#{name(request)}"
    end

    def name(%{method: method}) do
      String.upcase(method)
    end

    def to_string(request) do
      render(%{request: request})
    end

    @path Path.join("priv/spring_codegen", "request.ex.eex")
    EEx.function_from_file(:defp, :render, @path, [:assigns])
  end
end
