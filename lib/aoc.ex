defmodule Aoc do
  def main(["day", day_string | rest]) do
    parse_and_run(day_string, rest)
  end

  def main([day_string | rest]) do
    parse_and_run(day_string, rest)
  end

  def main(_), do: print_usage()

  defp parse_and_run(day_string, args) do
    case Integer.parse(day_string) do
      {day, _} -> run_day(day, args)
      :error -> print_usage()
    end
  end

  defp run_day(day, args) do
    module = day_module(day)

    if Code.ensure_loaded?(module) and function_exported?(module, :run, 1) do
      module.run(args)
    else
      IO.puts("Day #{day} not implemented yet")
    end
  end

  defp day_module(day) do
    case day do
      1 -> Day1
      2 -> Day2
      _ -> raise "Day #{day} not implemented yet"
    end
  end

  defp print_usage do
    IO.puts("""
    Usage:
      aoc <day> [args]

    Example:
      aoc 1
      aoc 2 input.txt
    """)
  end
end
