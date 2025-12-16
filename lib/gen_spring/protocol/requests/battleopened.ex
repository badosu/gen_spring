# codegen: do not edit
defmodule GenSpring.Protocol.Requests.BATTLEOPENED do
  @moduledoc """
  Sent by the server to all registered users, when a new battle becomes open.
  """

  words = [
    battleid: [description: nil, optional: false],
    type: [description: nil, optional: false],
    nattype: [description: nil, optional: false],
    founder: [description: nil, optional: false],
    ip: [description: nil, optional: false],
    port: [description: nil, optional: false],
    maxplayers: [description: nil, optional: false],
    passworded: [description: nil, optional: false],
    rank: [description: nil, optional: false],
    maphash: [description: nil, optional: false]
  ]

  sentences = [
    enginename: [description: nil, optional: false],
    engineversion: [description: nil, optional: false],
    map: [description: nil, optional: false],
    title: [description: nil, optional: false],
    gamename: [description: nil, optional: false],
    channel: [description: nil, optional: false]
  ]

  use GenSpring.Request,
    words: words,
    sentences: sentences
end
