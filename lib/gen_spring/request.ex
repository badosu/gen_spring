defmodule GenSpring.Request do
  def decode_unpacked(words, sentences, module, max_words) do
    {words, head_sentence} = Enum.split(words, max_words)
    head_sentence = Enum.join(head_sentence, " ")

    module.decode(words, [head_sentence | sentences])
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
    #
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

      @spring_field_names Keyword.keys(words ++ sentences)

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
         "Expected word count to be between #{@spring_min_words} and #{@spring_max_words}, received #{length(words)}"}
      end

      def decode(_words, sentences)
          when @spring_max_sentences < length(sentences) or
                 length(sentences) < @spring_min_sentences do
        {:error,
         "Expected sentence count to be between #{@spring_min_sentences} and #{@spring_max_sentences}, received #{length(sentences)}"}
      end

      def decode(words, sentences) do
        @spring_field_names |> Enum.zip(words ++ sentences) |> Map.new()
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
