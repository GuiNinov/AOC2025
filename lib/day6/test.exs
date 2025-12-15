defmodule Day6Test do
  use ExUnit.Case

  @example_input_1 """
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
  """
  @example_input_2 """
  123 328  51 64p
  p45 64  387 23p
  pp6 98  215 314
  *   +   *   +
    """

  describe "part 1" do
    test "processes input and returns grand total" do
      tmp_file = System.tmp_dir!() |> Path.join("day6_example.txt")
      File.write!(tmp_file, @example_input_1)
      try do
        content = Day6.parse_input(tmp_file)
        result = Day6.part_1(content)
        assert result == 4277556
      after
        File.rm(tmp_file)
      end
    end
  end


  describe "part 2" do
    test "processes input and returns grand total" do
      tmp_file = System.tmp_dir!() |> Path.join("day6_example.txt")
      File.write!(tmp_file, @example_input_2)
      try do
        content = Day6.parse_input(tmp_file)
        result = Day6.part_2(content)
        assert result == 3263827
      after
        File.rm(tmp_file)
      end
    end
  end

end
