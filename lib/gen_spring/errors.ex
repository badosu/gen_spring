defmodule GenSpring.InitError do
  defexception [:reason, :module_opts, :module]

  @impl Exception
  def message(init_error),
    do: "GenSpring server #{inspect(init_error.module)} failed to initialize"

  def exception(spring, reason) do
    fields =
      spring
      |> Map.take([:module, :module_opts])
      |> Map.put(:reason, reason)

    struct!(__MODULE__, fields)
  end
end

defmodule GenSpring.TransportError do
  @type transport_send_reason() :: :closed | {:timeout, rest_data :: binary()} | :inet.posix()
  @type reason() :: transport_send_reason() | term()

  defexception [:reason, :index]

  @impl Exception
  def message(_transport_error),
    do: "Failed to communicate with transport"

  @impl Exception
  def exception(reason, index \\ nil) do
    %__MODULE__{reason: reason, index: index}
  end
end

defmodule GenSpring.ParseError do
  defexception [:message]

  @impl Exception
  def exception(message), do: %__MODULE__{message: message}

  @impl Exception
  def message(_parse_error), do: "Failed to decode message from client"
end

defmodule GenSpring.EncodeError do
  defexception [:request]

  @impl Exception
  def exception(request), do: %__MODULE__{request: request}

  @impl Exception
  def message(_parse_error), do: "Failed to encode request from server"
end
