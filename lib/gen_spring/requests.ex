defmodule GenSpring.Requests do
  def unpack(message) do
    [head | sentences] = String.split(message, "\t")
    [method | words] = String.split(head, " ")

    {method, words, sentences}
  end

  def decode(message, registry) do
    {method, words, sentences} = unpack(message)

    if module = Map.get(registry, method) do
      module.decode_unpacked(words, sentences)
    else
      {:error, {:unregistered, method}}
    end
  end

  def encode(%module{} = request, registry) do
    if method = Map.get(registry, module) do
      module.encode(method, request)
    else
      {:error, {:unregistered, request}}
    end
  end

  def encode(bad_arg, _registry) do
    {:error, {:bad_arg, bad_arg}}
  end

  @doc false
  defmacro __using__(requests) when is_list(requests) do
    if not is_list(requests) do
      raise """
      invalid argument
      """
    end

    quote location: :keep do
      requests_method = unquote(requests)
      @request_registry requests_method |> Map.new()
      @method_registry Enum.map(requests_method, fn {met, req} -> {req, met} end) |> Map.new()

      def decode(message) do
        GenSpring.Requests.decode(message, @request_registry)
      end

      def encode(request) do
        GenSpring.Requests.encode(request, @method_registry)
      end
    end
  end
end
