defmodule AoC.Day02 do
  use AoC

  @test_input """
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  """

  @max_red 12
  @max_green 13
  @max_blue 14

  def part1 do
    get_input!(2)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_game/1)
    |> Enum.filter(&is_valid_game?/1)
    |> Enum.map(fn {game, _} -> game end)
    |> Enum.sum()
  end

  def part2 do
    get_input!(2)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_game/1)
    |> Enum.map(&fewest_cubes/1)
    |> Enum.map(&set_power/1)
    |> Enum.sum()
  end

  defp set_power(map) do
    Enum.reduce(map, 1, fn {_color, count}, acc -> acc * count end)
  end

  defp fewest_cubes({_, sets}) do
    Enum.reduce(sets, %{}, fn set, cubes ->
      Enum.reduce(set, cubes, fn {count, color}, cubes ->
        Map.put(cubes, color, max(count, Map.get(cubes, color, 0)))
      end)
    end)
  end

  defp is_valid_game?({_, sets}) do
    Enum.reduce(sets, true, fn set, acc1 ->
      Enum.reduce(set, acc1, fn 
        {count, "red"}, acc2 -> acc2 and count <= @max_red
        {count, "green"}, acc2 -> acc2 and count <= @max_green
        {count, "blue"}, acc2 -> acc2 and count <= @max_blue
      end)
    end)
  end

  defp parse_game(line) do
    [game, sets] = String.split(line, ": ")
    game_number = String.slice(game, 5..-1) |> String.to_integer()

    {game_number, parse_sets(sets)}
  end

  defp parse_sets(sets) do
    sets
    |> String.split("; ")
    |> Enum.map(&parse_set/1)
  end

  defp parse_set(set) do
    set
    |> String.split(", ")
    |> Enum.map(&parse_set_item/1)
  end

  defp parse_set_item(item) do
    [count, color] = String.split(item, " ")
    {String.to_integer(count), color}
  end
end
