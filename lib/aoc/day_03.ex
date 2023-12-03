defmodule AoC.Day03 do
  use AoC

  def part1 do
    schematic =
      get_input!(3)
      |> parse_schematic()

    symbols_locations = get_symbols(schematic) |> Map.keys() |> MapSet.new()

    schematic
    |> extract_numbers()
    |> Enum.filter(&is_part?(&1, symbols_locations))
    |> Enum.map(fn {_coords, number} -> String.to_integer(number) end)
    |> Enum.sum()
  end

  def part2 do
    schematic =
      get_input!(3)
      |> parse_schematic()

    all_numbers = extract_numbers(schematic)

    schematic
    |> get_symbols()
    |> Enum.filter(fn {_coords, ch} -> ch == "*" end)
    |> Enum.map(fn {coords, _ch} ->
      all_numbers
      |> Enum.filter(&is_part?(&1, MapSet.new([coords])))
      |> Enum.map(fn {_coords, number} -> String.to_integer(number) end)
    end)
    # adjacent to exactly two part numbers
    |> Enum.filter(fn list -> length(list) == 2 end)
    # calc gear ratio
    |> Enum.map(fn [a, b] -> a * b end)
    |> Enum.sum()
  end

  defp is_part?({coords, _number}, symbols) do
    coords
    |> Enum.map(&adjacents/1)
    |> List.flatten()
    |> Enum.any?(fn {x, y} -> MapSet.member?(symbols, {x, y}) end)
  end

  defp extract_numbers(schematic) do
    schematic
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      parse_row(row, y, acc)
    end)
  end

  def parse_row(row, y, acc) do
    row
    |> Enum.with_index()
    |> parse_row("", [], y, acc)
  end

  defp parse_row([{ch, _x} | _] = row, buffer, coords_buffer, y, numbers) do
    if is_digit(ch) do
      parse_row_digit(row, buffer, coords_buffer, y, numbers)
    else
      parse_row_char(row, buffer, coords_buffer, y, numbers)
    end
  end

  defp parse_row([], "", _buffer_start, _y, numbers),
    do: numbers

  defp parse_row([], buffer, coords_buffer, _y, numbers),
    do: Map.put(numbers, coords_buffer, buffer)

  defp parse_row_digit([{ch, x} | rest], buffer, coords_buffer, y, numbers),
    do: parse_row(rest, buffer <> ch, [{x, y} | coords_buffer], y, numbers)

  defp parse_row_char([_ | rest], "", [], y, numbers),
    do: parse_row(rest, "", [], y, numbers)

  defp parse_row_char([_ | rest], buffer, coords_buffer, y, numbers),
    do: parse_row(rest, "", [], y, Map.put(numbers, coords_buffer, buffer))

  defp parse_schematic(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
  end

  defp get_symbols(schematic) do
    schematic
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {ch, x}, acc ->
        if is_symbol(ch) do
          Map.put(acc, {x, y}, ch)
        else
          acc
        end
      end)
    end)
  end

  defp is_symbol(value) do
    not String.match?(value, ~r/^\d+$/) and value != "."
  end

  defp adjacents({x, y}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end

  defp is_digit(value) do
    String.match?(value, ~r/^\d+$/)
  end
end
