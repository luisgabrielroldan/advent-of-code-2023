defmodule Mix.Tasks.Exec do
  use Mix.Task

  @shortdoc "Runs the solution for a given day and part"

  def run(args) do
    {day, part} = parse_args(args)
    day_module = day_module(day)
    part_function = "part#{part}" |> String.to_atom()

    day_module
    |> function_exists?(part_function)
    |> case do
      true -> run!(day_module, part_function)
      false -> IO.puts("Day #{day} part #{part} not implemented!")
    end
  end

  defp parse_args([day]) do
    {String.to_integer(day), 1}
  end

  defp parse_args([day, part]) do
    {String.to_integer(day), String.to_integer(part)}
  end

  defp parse_args(_) do
    raise "Invalid arguments"
  end

  defp run!(day_module, part_function) do
    result =
      day_module
      |> apply(part_function, [])

    IO.puts(result || "No result. Check the code!")
  end

  defp day_module(day) do
    "Elixir.AoC.Day#{String.pad_leading(Integer.to_string(day), 2, "0")}" |> String.to_atom()
  end

  defp function_exists?(day_module, part_function) do
    case Code.ensure_loaded(day_module) do
      {:module, _} ->
        Keyword.has_key?(day_module.__info__(:functions), part_function)

      {:error, _} ->
        false
    end
  end
end
