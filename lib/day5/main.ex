defmodule Day5 do
  def run([]) do
    run(["lib/day5/input.txt"])
  end

  def run([path | _]) do
    execute(path)
  end

  def execute(path) do
    { fresh_ranges, available_ingredient_ids } = parse_input(path)

    result = part_1(fresh_ranges, available_ingredient_ids)

    IO.inspect("Part 1 Result: #{result}")

    result2 = part_2(fresh_ranges)

    IO.inspect("Part 2 Result: #{result2}")
  end

  def parse_input(path) do
    lines = path |> File.read!() |> String.split("\n")

    lines
    |> Enum.split_while(fn line -> line != "" end)
    |> then(fn {fresh_ranges, rest} ->
      fresh_ranges = fresh_ranges
        |> Enum.filter(fn line -> line != "" end)
        |> Enum.map(fn range ->
          [min, max] = String.split(range, "-")
          [String.to_integer(min), String.to_integer(max)]
        end)

      available_ingredient_ids = rest
        |> Enum.drop(1)
        |> Enum.filter(fn line -> line != "" and String.trim(line) != "" end)
        |> Enum.map(&String.to_integer/1)

      {fresh_ranges, available_ingredient_ids}
    end)
  end

  def part_1(fresh_ranges, available_ingredient_ids) do
    Enum.reduce(available_ingredient_ids, 0, fn id, acc ->
      if Enum.any?(fresh_ranges, fn range -> id >= Enum.at(range, 0) and id <= Enum.at(range, 1) end) do
        acc + 1
      else
        acc
      end
    end)
  end

  def part_2(fresh_ranges) do
    sorted_ranges = Enum.sort_by(fresh_ranges, fn [min, _max] -> min end)

    merged = Enum.reduce(sorted_ranges, [], fn [min, max], acc ->
      case acc do
        [] -> [[min, max]]
        [[prev_min, prev_max] | rest] ->
          if min <= prev_max + 1 do
            [[prev_min, max(prev_max, max)] | rest]
          else
            [[min, max] | acc]
          end
      end
    end)
    |> Enum.reverse()

    Enum.reduce(merged, 0, fn [min, max], acc ->
      acc + (max - min + 1)
    end)
  end
end
