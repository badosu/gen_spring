defmodule GenSpring.Requests do
  def parse(message) when is_binary(message) do
    [head | sentences] = String.split(message, "\t")
    [method | words] = String.split(head, " ")

    # new(method, words, sentences)
  end

  def parse(method, words, sentences, attrs) do
    %{method: method, words: words, sentences: sentences}
  end
end
