defmodule Day4Test do
  use ExUnit.Case

  @example_input """
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
  """

  describe "part 1" do
    test "processes input and returns count of accessible rolls" do
      tmp_file = System.tmp_dir!() |> Path.join("day4_example.txt")
      File.write!(tmp_file, @example_input)
      try do
        lines_only = Day4.parse_input(tmp_file)
        matrix = Day4.parse_matrix(lines_only)
        result = Day4.part_1(matrix)
        assert result == 13
      after
        File.rm(tmp_file)
      end
    end
  end

  describe "part 2" do
    test "processes input and returns count of accessible rolls" do
      tmp_file = System.tmp_dir!() |> Path.join("day4_example.txt")
      File.write!(tmp_file, @example_input)
      try do
        lines_only = Day4.parse_input(tmp_file)
        matrix = Day4.parse_matrix(lines_only)
        result = Day4.part_2(matrix)
        assert result == 43
      after
        File.rm(tmp_file)
      end
    end
  end
end
