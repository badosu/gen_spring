defmodule SpringCodegen.Request do
  @moduledoc """
  Represents a LSP request
  """
  alias SpringCodegen.Param

  use TypedStruct

  typedstruct do
    field(:description, String.t())
    field(:params, list(SpringCodegen.Param.t()))
    field(:responses, list(Map.t()))
    field(:source, :client | :server)
    field(:method, String.t())
    field(:examples, list(String.t()))
  end

  def new(request) do
    %__MODULE__{
      method: request[:method],
      source: String.to_existing_atom(request[:source]),
      description: request[:description],
      params: for(param <- Map.get(request, :params, []), do: Param.new(param)),
      responses: request[:responses],
      examples: request[:examples]
    }
  end

  defimpl SpringCodegen.Codegen do
    require EEx

    def module_name(request) do
      "GenSpring.Requests.#{name(request)}"
    end

    def name(%{method: method}) do
      String.downcase(method)
      |> Macro.camelize()
    end

    @path Path.join(:code.priv_dir(:gen_spring), "request.ex.eex")

    def to_string(request, metamodel) do
      render(%{
        request: request,
        params: request.params,
        metamodel: metamodel
      })
    end

    EEx.function_from_file(:defp, :render, @path, [:assigns])
  end
end
