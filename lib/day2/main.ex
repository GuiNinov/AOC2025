defmodule Day2 do
  def run([]) do
    run(["lib/day2/input.txt"])
  end

  def run([path | _]) do
    execute(path)
  end

  def execute(path) do
    content = parse_input(path)
    invalid_numbers =
      content
      |> Enum.flat_map(fn range -> handle_range(range, &is_invalid_number_part_1/1) end)

    IO.inspect(invalid_numbers, label: "Invalid numbers")
    result = consolidate_invalid_numbers(invalid_numbers)
    IO.puts("Result for part 1: #{result}")

    invalid_numbers_part_2 =
      content
      |> Enum.flat_map(fn range -> handle_range(range, &is_invalid_number_part_2/1) end)

    IO.inspect(invalid_numbers_part_2, label: "Invalid numbers part 2")
    result2 = consolidate_invalid_numbers(invalid_numbers_part_2)
    IO.puts("Result for part 2: #{result2}")
  end

  def parse_input(path) do
    path
    |> File.read!()
    |> String.split(",", trim: true)
  end

  def handle_range(range, filter_function) do
    [start, finish] = String.split(range, "-")
    start_number = String.to_integer(start)
    finish_number = String.to_integer(finish)

    start_number..finish_number
    |> Enum.filter(filter_function)
  end

  def is_invalid_number_part_1(number) do
    number_str = Integer.to_string(number)
    length = number_str |> String.length()

    half = div(length, 2)

    first_half = String.slice(number_str, 0, half)
    second_half = String.slice(number_str, half, length - half)

    first_half == second_half
  end

  def is_invalid_number_part_2(number) do
    number_str = Integer.to_string(number)
    len = String.length(number_str)

    if len < 2 do
      IO.puts("Number #{number} is too short")
      false
    else
      1..div(len, 2)
      |> Enum.any?(fn size ->
        if rem(len, size) != 0 do
          false
        else
          chunks = div(len, size)

          parts =
            Enum.map(0..(chunks - 1), fn j ->
              String.slice(number_str, j * size, size)
            end)

          chunks >= 2 and (Enum.uniq(parts) |> length) == 1
        end
      end)
    end
  end


  def consolidate_invalid_numbers(invalid_numbers) do
    invalid_numbers
    |> Enum.sum()
  end
end
