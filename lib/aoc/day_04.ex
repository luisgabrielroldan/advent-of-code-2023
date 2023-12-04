defmodule AoC.Day04 do
  use AoC

  def part1 do
    input = get_input!(4)

    input
    |> parse_cards()
    |> Enum.map(&get_matches/1)
    |> Enum.map(&get_score/1)
    |> Enum.sum()
  end

  def part2 do
    input = get_input!(4)

    input
    |> parse_cards()
    |> Enum.map(fn card -> {1, get_matches(card) |> length()} end)
    |> process_cards()
  end

  defp process_cards(cards, acc \\ 0)

  defp process_cards([], acc), do: acc

  defp process_cards([{count, matches} | rest], acc) do
    {to_copy, rest} = Enum.split(rest, matches)

    to_copy
    |> Enum.map(fn {c, m} -> {c + count, m} end)
    |> Enum.concat(rest)
    |> process_cards(acc + count)
  end

  defp get_matches({_, winners, nums}) do
    winners = MapSet.new(winners)
    nums = MapSet.new(nums)

    MapSet.intersection(winners, nums)
    |> MapSet.to_list()
  end

  defp get_score([]), do: 0

  defp get_score(matches) do
    2 ** (length(matches) - 1)
  end

  defp parse_cards(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [[card_num], winners, numbers] =
        line
        |> String.slice(5..-1)
        |> String.split(~r/[:|]/)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.split(&1, " "))
        |> Enum.map(fn numbers ->
          numbers
          |> Enum.reject(&(&1 == ""))
          |> Enum.map(&String.to_integer/1)
        end)

      {card_num, winners, numbers}
    end)
  end
end
