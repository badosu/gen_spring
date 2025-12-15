# codegen: do not edit
defmodule GenSpring.Requests.Redirect do
  @moduledoc """
  Sent by the server when running in "redirection mode".
        When a client connects, the server will send him only this message
        and disconnect the socket immediately.
        The client should connect to the given IP and port, in that case.
        This command may be useful when the official server ip/address changes,
        so that clients are automatically redirected to the new one.
  """

  words = [ip: [description: nil, optional: true],
 port: [description: nil, optional: true]]
  sentences = []

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
