defmodule GenSpring.Request do
  @doc false
  def decode_unpacked(words, sentences, module, max_words)
      when max_words > 0 and length(words) > max_words do
    {words, head_sentence} = Enum.split(words, max_words)
    head_sentence = Enum.join(head_sentence, " ")

    module.decode(words, [head_sentence | sentences])
  end

  @doc false
  def decode_unpacked(words, sentences, module, _max_words) do
    module.decode(words, sentences)
  end

  @doc false
  def encode_body(map, word_keys, sentence_keys) do
    # FIXME: This is kinda ridiculous, but quick n dirty
    words =
      map_sorted_values(map, word_keys)

    # NOTE:
    # Weird thing where last sentence is a word
    # %GenSpring.Protocol.Requests.LOGIN{
    #  username: "a",
    #  password: "b",
    #  cpu: "0",
    #  localip: "c",
    #  lobby_name_and_version: "lobby name",
    #  compflags: "comp"
    # } => {:ok, "LOGIN a b 0 c lobby name\tcomp\n"}

    map_sorted_values(map, sentence_keys)
    |> case do
      [] ->
        List.foldl(words, "", fn x, acc -> "#{acc} #{x}" end)

      [head | sentences] ->
        words = words ++ [head]
        words = List.foldl(words, "", fn x, acc -> "#{acc} #{x}" end)
        sentences = List.foldl(sentences, "", fn x, acc -> "#{acc}\t#{x}" end)

        "#{words}#{sentences}"
    end
  end

  defp map_sorted_values(map, keys) do
    Map.take(map, keys)
    |> Map.reject(&is_nil(elem(&1, 1)))
    |> Enum.sort_by(&Enum.find_index(keys, fn el -> el == elem(&1, 0) end))
    |> Enum.map(&elem(&1, 1))
  end

  @doc false
  defmacro __using__(command) when is_list(command) do
    if not is_list(command) do
      raise """
      @spring_command module attribute not defined
      """
    end

    # method = Keyword.fetch!(command, :method)
    #
    # if not is_binary(method) do
    #   raise """
    #   missing :method option
    #   """
    # end

    words = Keyword.fetch!(command, :words)
    sentences = Keyword.fetch!(command, :sentences)

    [
      request_struct(words, sentences),
      request_body(words, sentences)
    ]
  end

  def request_body(words, sentences) do
    quote location: :keep do
      words = unquote(words)
      sentences = unquote(sentences)

      @spring_words unquote(words)
      @spring_sentences unquote(sentences)

      @spring_word_names Keyword.keys(words)
      @spring_sentence_names Keyword.keys(sentences)
      @spring_field_names @spring_word_names ++ @spring_sentence_names

      @spring_max_words length(words)
      @spring_min_words Enum.count(words, &(not (elem(&1, 1) |> Keyword.get(:optional, false))))

      @spring_max_sentences length(sentences)
      @spring_min_sentences Enum.count(
                              sentences,
                              &(not (elem(&1, 1) |> Keyword.get(:optional, false)))
                            )

      def decode_unpacked(words, sentences) do
        GenSpring.Request.decode_unpacked(words, sentences, __MODULE__, @spring_max_words)
      end

      def decode(words, _sentences)
          when @spring_max_words < length(words) or length(words) < @spring_min_words do
        {:error,
         "expected word count to be between #{@spring_min_words} and #{@spring_max_words}, received #{length(words)}"}
      end

      def decode(_words, sentences)
          when @spring_max_sentences < length(sentences) or
                 length(sentences) < @spring_min_sentences do
        {:error,
         "expected sentence count to be between #{@spring_min_sentences} and #{@spring_max_sentences}, received #{length(sentences)}"}
      end

      def decode(words, sentences) do
        fields = @spring_field_names |> Enum.zip(words ++ sentences) |> Map.new()

        {:ok, struct!(__MODULE__, fields)}
      end

      def encode(method, %__MODULE__{} = request) do
        body =
          Map.from_struct(request)
          |> GenSpring.Request.encode_body(@spring_word_names, @spring_sentence_names)

        {:ok, "#{method}#{body}\n"}
      end

      def encode(method, request) do
        {:error, {:bad_arg, method, request}}
      end
    end
  end

  def request_struct(words, sentences) do
    quote location: :keep do
      use TypedStruct

      typedstruct do
        @typedoc "A person"

        fields = unquote(words) ++ unquote(sentences)

        for {field_name, opts} <- fields do
          field(field_name, String.t(), enforce: not Keyword.get(opts, :optional, false))
        end
      end
    end
  end
end
