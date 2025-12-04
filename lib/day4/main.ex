defmodule Day4 do
  def run([]) do
    run(["lib/day4/input.txt"])
  end

  def run([path | _]) do
    execute(path)
  end

  def execute(path) do
    lines_only = parse_input(path)

    matrix = parse_matrix(lines_only)

    part_1(matrix)

    part_2(matrix)

  end

  def part_1(matrix) do
    total = count_accessible_rolls(matrix)

    IO.inspect(total, label: "Total Part 1: #{total}")

    total
  end

  def part_2(matrix) do

    total = count_and_remove_until_done(matrix, 0)

    IO.inspect(total, label: "Total Part 2: #{total}")

    total
  end

  def parse_input(path) do
    path |> File.read!() |> String.split("\n")
  end

  def parse_matrix(lines_only) do
    lines_only
    |> Enum.map(fn line -> String.graphemes(line) end)
  end

  def count_accessible_rolls(matrix) do
    matrix
      |> Enum.with_index()
      |> Enum.reduce(0, fn {row, row_index}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {cell, col_index}, inner_acc ->
          if cell == "@" do
            adjacent_rolls = get_adjacent_rolls(row_index, col_index, matrix)

            if Enum.count(adjacent_rolls) < 4 do
              inner_acc + 1
            else
              inner_acc
            end
          else
            inner_acc
          end
        end)
      end)
  end

  def get_adjacent_rolls(row, col, matrix) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
    |> Enum.filter(fn {r, c} ->
      r >= 0 and r < length(matrix) and
      c >= 0 and c < length(Enum.at(matrix, r, [])) and
      Enum.at(Enum.at(matrix, r, []), c) == "@"
    end)
  end

  def remove_accessible_rolls(matrix) do
    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {cell, col_index} ->
        adjacent_rolls = get_adjacent_rolls(row_index, col_index, matrix)

        if Enum.count(adjacent_rolls) < 4 do
          "."
        else
          cell
        end
      end)
    end)
  end

  def count_and_remove_until_done(matrix, counter) do
    available_rolls = count_accessible_rolls(matrix)
    if available_rolls == 0 do
      counter
    else
      new_counter = counter + available_rolls
      new_matrix = remove_accessible_rolls(matrix)
      count_and_remove_until_done(new_matrix, new_counter)
    end
  end

end
