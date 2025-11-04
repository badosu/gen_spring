# codegen: do not edit
defmodule GenSpring.Requests.Register do
  @moduledoc """
  The client sends this command when trying to register a new account. Note that the client must not already be logged in, or else the server will deny his request. The username and password are given sanity/uniqueness checks, and these primarily determine the servers response. If email verification is enabled, and no valid email address is provided, the server will deny the registration.

  Source: client
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "REGISTER"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
