defmodule Day3 do
  def run([]) do
    run(["lib/day3/input.txt"])
  end

  def run([path | _]) do
    execute(path)
  end

  def execute(path) do
    content = parse_input(path)

    total_part_1 = Enum.reduce(content, 0, fn bank, acc ->
      number = max_two_digits_bank_value(bank)
      acc + number
    end)

    IO.inspect(total_part_1, label: "Total Part 1: #{total_part_1}")

    total_part_2 = Enum.reduce(content, 0, fn bank, acc ->
      number = max_joltage_12(bank)
      acc + number
    end)

    IO.inspect(total_part_2, label: "Total Part 2: #{total_part_2}")
  end

  def parse_input(path) do
    path |> File.read!() |> String.split("\n")
  end

  def max_two_digits_bank_value(bank) do
    digits =
      bank
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    Enum.with_index(digits)
    |> Enum.flat_map(fn {d1, i} ->
      Enum.drop(digits, i + 1)
      |> Enum.map(fn d2 -> d1 * 10 + d2 end)
    end)
    |> Enum.max()
  end

  def max_joltage_12(bank) do
    digits = String.graphemes(bank)
    remove = length(digits) - 12

    {stack, _} =
      Enum.reduce(digits, {[], remove}, fn digit, {stack, rem} ->
        {stack, rem} =
          while_pop(stack, digit, rem)

        {[digit | stack], rem}
      end)

    stack
    |> Enum.reverse()
    |> Enum.take(12)
    |> Enum.join()
    |> String.to_integer()
  end

  defp while_pop([top | rest], digit, rem)
     when rem > 0 and top < digit do
    while_pop(rest, digit, rem - 1)
  end

  defp while_pop(stack, _digit, rem), do: {stack, rem}
end
