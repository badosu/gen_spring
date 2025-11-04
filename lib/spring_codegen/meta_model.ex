defmodule SpringCodegen.MetaModel do
  @moduledoc """
  The actual meta model.
  """

  alias SpringCodegen.{Util, Request}

  use TypedStruct

  typedstruct enforce: true do
    field(:requests, list(Request.t()))
    field(:version, String.t())
  end

  def new(%{metadata: %{version: version}, requests: requests}) do
    %__MODULE__{
      requests: for(request <- requests, do: Request.new(request)),
      version: version
    }
  end

  def new(%{} = protocol), do: new(Util.atomize_keys(protocol))
end
