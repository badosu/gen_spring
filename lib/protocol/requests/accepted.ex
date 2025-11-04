# codegen: do not edit
defmodule GenSpring.Requests.Accepted do
  @moduledoc """
  Sent as a response to the LOGIN command, if it succeeded. Next, the server will send much info about clients and battles:*multiple MOTD, each giving one line of the current welcome message
  * multiple ADDUSER, listing all users currently logged in
  * multiple BATTLEOPENED, UPDATEBATTLEINFO, detailing the state of all currently open battles
  * multiple JOINEDBATTLE, indiciating the clients present in each battle
  * multiple CLIENTSTATUS, detailing the statuses of all currently logged in usersFinally, it will send a LOGININFOEND command indicating that it has finished sending all this info. Note that, except for this final command, the commands/info listed above may be sent to the client in any order.

  Source: server
  """

  use TypedStruct

  typedstruct do
    field :method, String.t(), default: "ACCEPTED"
    field :id, integer() | String.t()
    field :params, Map.t()
  end
end
