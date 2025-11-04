defmodule SpringCodegen.Util do
  def atomize_keys(data) when is_map(data) do
    Enum.reduce(data, %{}, fn {key, value}, acc ->
      atomized_key = if is_binary(key), do: String.to_atom(key), else: key
      Map.put(acc, atomized_key, atomize_keys(value))
    end)
  end

  def atomize_keys(data) when is_list(data) do
    Enum.map(data, &atomize_keys/1)
  end

  def atomize_keys(data), do: data
end
