defmodule AoC do
  defmacro __using__(_opts) do
    quote do
      import AoC
    end
  end

  def get_input!(day) do
    day_number = String.pad_leading(Integer.to_string(day), 2, "0")
    File.read!("inputs/day_#{day_number}.txt") |> String.trim()
  end
end
