defmodule Day5Test do
  use ExUnit.Case

  @example_input """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
  """

  describe "part 1" do
    test "processes input and returns count of fresh ingredients" do
      tmp_file = System.tmp_dir!() |> Path.join("day5_example.txt")
      File.write!(tmp_file, @example_input)
      try do
        { fresh_ranges, available_ingredient_ids } = Day5.parse_input(tmp_file)
        result = Day5.part_1(fresh_ranges, available_ingredient_ids)
        assert result == 3
      after
        File.rm(tmp_file)
      end
    end
  end

  describe "part 2" do
    test "processes input and returns count of fresh ingredients" do
      tmp_file = System.tmp_dir!() |> Path.join("day5_example.txt")
      File.write!(tmp_file, @example_input)
      try do
        { fresh_ranges, available_ingredient_ids } = Day5.parse_input(tmp_file)
        result = Day5.part_2(fresh_ranges)
        assert result == 14
      after
        File.rm(tmp_file)
      end
    end
  end
end
