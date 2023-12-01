defmodule AoC.Day01 do
  use AoC

  def part1 do
    get_input!(1)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&find_numbers/1)
    |> Enum.sum()
  end

  def part2 do
    get_input!(1)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&replace_numbers/1)
    |> Enum.map(&find_numbers/1)
    |> Enum.sum()
  end

  defp replace_numbers(<<"one", _::binary>> = str) do
    <<_, rest::binary>> = str
    "1" <> replace_numbers(rest)
  end

  defp replace_numbers(<<"two", _::binary>> = str) do
    <<_, rest::binary>> = str
    "2" <> replace_numbers(rest)
  end

  defp replace_numbers(<<"three", _::binary>> = str) do
    <<_, rest::binary>> = str
    "3" <> replace_numbers(rest)
  end

  defp replace_numbers(<<"four", _::binary>> = str) do
    <<_, rest::binary>> = str
    "4" <> replace_numbers(rest)
  end

  defp replace_numbers(<<"five", _::binary>> = str) do
    <<_, rest::binary>> = str
    "5" <> replace_numbers(rest)
  end

  defp replace_numbers(<<"six", _::binary>> = str) do
    <<_, rest::binary>> = str
    "6" <> replace_numbers(rest)
  end

  defp replace_numbers(<<"seven", _::binary>> = str) do
    <<_, rest::binary>> = str
    "7" <> replace_numbers(rest)
  end

  defp replace_numbers(<<"eight", _::binary>> = str) do
    <<_, rest::binary>> = str
    "8" <> replace_numbers(rest)
  end

  defp replace_numbers(<<"nine", _::binary>> = str) do
    <<_, rest::binary>> = str
    "9" <> replace_numbers(rest)
  end

  defp replace_numbers(<<ch, rest::binary>>), do: <<ch>> <> replace_numbers(rest)
  defp replace_numbers(""), do: ""

  defp find_numbers(str) when is_binary(str) do
    str |> to_charlist |> find_numbers([]) |> to_string |> String.to_integer()
  end

  defp find_numbers([], [ch]) do
    [ch, ch]
  end

  defp find_numbers([], acc) do
    [Enum.at(acc, -1), Enum.at(acc, 0)]
  end

  defp find_numbers([ch | rest], acc) when ch in ?0..?9 do
    find_numbers(rest, [ch | acc])
  end

  defp find_numbers([_ch | rest], acc) do
    find_numbers(rest, acc)
  end
end
