defmodule Day6 do
  def run([]) do
    run(["lib/day6/input.txt"])
  end

  def run([path | _]) do
    execute(path)
  end

  def execute(path) do
    content = parse_input(path)

    result = part_1(content)

    IO.inspect("Part 1 Result: #{result}")

    result2 = part_2(content)

    IO.inspect("Part 2 Result: #{result2}")
  end

  def parse_input(path) do
    path |> File.read!() |> String.split("\n", trim: true)
  end

  def part_1(lines) do
    content = format_lines(lines)

    terms = length(content) - 2
    operations_per_column = length(Enum.at(content, 0)) - 1
    operations = Enum.at(content, length(content) - 1)

    Enum.reduce(0..operations_per_column, 0, fn column, acc ->
      column_result = Enum.reduce(0..terms, 0, fn term_index, inner_acc ->
        line = Enum.at(content, term_index)
        term = Enum.at(line, column) |> String.to_integer()
        operation = Enum.at(operations, column)
        result = case operation do
          "*" ->
            if inner_acc == 0 do
              term
            else
              inner_acc * term
            end

          "+" -> inner_acc + term
        end
        result
      end)
      acc + column_result
    end)
  end

  def format_lines(lines) do
    lines
    |> Enum.reduce([], fn line, acc ->

      if line == "" do
        [acc]
      else
        new_line = String.split(line, " ")
        |> Enum.filter(fn x -> x != "" and x != " " end)
        |> Enum.map(fn x -> String.split(x, "p") |> Enum.filter(fn x -> x != "" end) |> Enum.join("") end)
        acc ++ [new_line]
      end
    end
    )
  end

  def part_2(content) do
    {processed_operations, problems_graphemes} = format_lines_part_2(content)
    IO.inspect(processed_operations, label: "Processed operations")
    IO.inspect(problems_graphemes, label: "Problems graphemes")

    result = Enum.reduce(processed_operations, 0, fn ops, acc ->
      IO.inspect("Starting processing for new operation")
      start_index = ops.start_index
      graphemes_to_next = ops.graphemes_to_next


      IO.inspect("Start index: #{start_index}, Graphemes to next: #{graphemes_to_next}, Operation: #{ops.operation}, Acc: #{acc}")

      range = if graphemes_to_next == 0 do
        start_index..((Enum.at(problems_graphemes, 0) |> length() )- 1)
      else
        start_index..(start_index + graphemes_to_next - 1)
      end
      inner_res = range
      |> Enum.reverse()
      |> Enum.reduce(0, fn index, inner_acc ->
        first_factor = Enum.at(problems_graphemes, 0) |> Enum.at(index)
        second_factor = Enum.at(problems_graphemes, 1) |> Enum.at(index)
        third_factor = Enum.at(problems_graphemes, 2) |> Enum.at(index)
        fourth_factor = Enum.at(problems_graphemes, 3) |> Enum.at(index)

        IO.inspect("First factor: #{first_factor}, Second factor: #{second_factor}, Third factor: #{third_factor}, Inner acc: #{inner_acc}")
        first_factor_int = case first_factor == " " or first_factor == "p" do
          true -> 0
          false -> String.to_integer(first_factor)
        end

        second_factor_int = case second_factor == " " or second_factor == "p" do
          true -> 0
          false -> String.to_integer(second_factor)
        end

        third_factor_int = case third_factor == " " or third_factor == "p" do
          true -> 0
          false -> String.to_integer(third_factor)
        end

        fourth_factor_int = case fourth_factor == " " or fourth_factor == "p" do
          true -> 0
          false -> String.to_integer(fourth_factor)
        end

        factors = [first_factor_int, second_factor_int, third_factor_int, fourth_factor_int]
        first_factor_multiple = factors |> Enum.slice(1..3) |> Enum.filter(fn x -> x != 0 end) |> length()
        second_factor_multiple = factors |> Enum.slice(2..4) |> Enum.filter(fn x -> x != 0 end) |> length()
        third_factor_multiple = factors |> Enum.slice(3..4) |> Enum.filter(fn x -> x != 0 end) |> length()

        factor = first_factor_int * (10**first_factor_multiple) + second_factor_int * (10**second_factor_multiple) + third_factor_int * (10**third_factor_multiple) + fourth_factor_int

        IO.inspect("Factor: #{factor}")
        result = if ops.operation == "+" do
          inner_acc + factor
        else
          if inner_acc == 0 do
            factor
          else
            inner_acc * factor
          end
        end
        result
      end)
      IO.inspect("Inner result: #{inner_res}")
      new_acc = acc + inner_res
      IO.inspect("Accumulator: #{new_acc}")
      IO.inspect("--------------------------------")
      new_acc
    end)

    result
  end


  def format_lines_part_2(lines) do
    operations = Enum.at(lines, length(lines) - 1)
    problems = Enum.drop(lines, -1)

    processed_operations = process_operations(operations |> String.graphemes())

    problems_graphemes = problems |> Enum.map(fn problem -> problem |> String.graphemes() end)

    {processed_operations, problems_graphemes}
  end


  def process_operations(operations_graphemes) do
    operations_graphemes
    |> Enum.with_index()
    |> Enum.filter(fn {grapheme, _index} -> grapheme == "+" or grapheme == "*" end)
    |> Enum.map(fn {operation, index} ->
      next_op_index = Enum.find_index(Enum.drop(operations_graphemes, index + 1),
        fn grapheme -> grapheme == "+" or grapheme == "*" end)

      graphemes_to_next = case next_op_index do
        nil -> length(operations_graphemes) - index - 1
        idx -> idx + 1
      end

      %{
        operation: operation,
        graphemes_to_next: graphemes_to_next,
        start_index: index
      }
    end)
  end
end
