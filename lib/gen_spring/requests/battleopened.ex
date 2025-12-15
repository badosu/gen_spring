# codegen: do not edit
defmodule GenSpring.Requests.Battleopened do
  @moduledoc """
  Sent by the server to all registered users, when a new battle becomes open.
  """

  words = [battleid: [description: nil, optional: true],
 type: [description: nil, optional: true],
 nattype: [description: nil, optional: true],
 founder: [description: nil, optional: true],
 ip: [description: nil, optional: true],
 port: [description: nil, optional: true],
 maxplayers: [description: nil, optional: true],
 passworded: [description: nil, optional: true],
 rank: [description: nil, optional: true],
 maphash: [description: nil, optional: true]]
  sentences = [enginename: [description: nil, optional: true],
 engineversion: [description: nil, optional: true],
 map: [description: nil, optional: true],
 title: [description: nil, optional: true],
 gamename: [description: nil, optional: true],
 channel: [description: nil, optional: true]]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
