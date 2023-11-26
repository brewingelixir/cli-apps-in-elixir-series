defmodule WC do
  def run(args) do
    args
    |> parse_options()
    |> execute()
  end

  def parse_options(args) do
    OptionParser.parse(args,
      aliases: [l: :lines, w: :words, c: :chars],
      switches: [chars: :boolean, words: :boolean, lines: :boolean]
    )
  end

  def execute(options) do
    {file, opts} =
      case options do
        {opts, [], _} ->
          {:stdio, opts}

        {opts, [file | _], _} ->
          {file, opts}
      end

    case read_file(file) do
      {:ok, content} ->
        content
        |> count_content()
        |> print_results(file, opts)

      {:error, :file_not_found} ->
        IO.puts("File not found: #{file}")
        System.halt(1)
    end
  end

  @default_opts [lines: true, words: true, chars: true]

  def print_results(results, file, []) do
    print_results(results, file, @default_opts)
  end

  def print_results(results, file, opts) do
    result =
      Enum.reduce(@default_opts, "", fn {key, _}, acc ->
        if opts[key] do
          acc <> "\t#{results[key]}"
        else
          acc
        end
      end)

    if file == :stdio do
      IO.puts(result <> " " <> "\n")
    else
      IO.puts(result <> " " <> file <> "\n")
    end
  end

  def count_content(content) do
    content
    |> String.graphemes()
    |> Enum.reduce(%{lines: 0, words: 0, chars: 0}, fn char, acc ->
      cond do
        char == "\n" ->
          %{acc | lines: acc.lines + 1, chars: acc.chars + 1, words: acc.words + 1}

        char in [" ", "\t"] ->
          %{acc | words: acc.words + 1, chars: acc.chars + 1}

        true ->
          %{acc | chars: acc.chars + 1}
      end
    end)
  end

  def read_file(:stdio) do
    {:ok, IO.read(:stdio, :all)}
  end

  def read_file(file) do
    if File.exists?(file) do
      File.read(file)
    else
      {:error, :file_not_found}
    end
  end
end

## Specifics
#
# -m, --chars print the character counts
# -l, --lines print the newline counts
# -w, --words print the word counts 

args = System.argv()
WC.run(args)
