defmodule GenSpring.Requests do
  def parse(message) when is_binary(message) do
    [head | sentences] = String.split(message, "\t")
    [method | words] = String.split(head, " ")

    # new(method, words, sentences)
  end

  def parse(method, words, sentences, attrs) do
    %{method: method, words: words, sentences: sentences}
  end

  def parse_incoming(_message) do
    {:ok,
     %{
       battle_id: "1234",
       type: 0,
       nat_type: 0,
       founder: "player",
       ip: "127.0.0.1",
       port: 4001,
       max_players: 8,
       passworded: 1,
       rank: 0,
       map_hash: 12345,
       engine_name: "custom_spring",
       engine_version: "94.1.1-1062-g9d16c2d develop",
       map: "Coastline_Dry_V1",
       title: "The BlackHoleHost - Conflict",
       game_name: "Some Game V0.0.1",
       channel: "__battle__1234"
     }}
  end
end
