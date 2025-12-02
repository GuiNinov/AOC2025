defmodule Day1 do
  @first_allowed_position 0
  @last_allowed_position 99
  @start_position 50
  @start_counter 0
  @start_pass_through 0
  @reference_position 0

  def move(code, {position, counter, pass_through}) do
    direction = String.slice(code, 0, 1)

    distance =
      code
      |> String.slice(1, String.length(code))
      |> String.to_integer()

    iteration_size = @last_allowed_position - @first_allowed_position + 1

    offset = position - @first_allowed_position

    new_offset =
      case direction do
        "L" ->
          IO.puts("From Position: #{position}, Direction: #{direction}, Reducing position by #{distance}")
          Integer.mod(offset - distance, iteration_size)

        "R" ->
          IO.puts("From Position: #{position}, Direction: #{direction}, Increasing position by #{distance}")
          Integer.mod(offset + distance, iteration_size)
      end

    new_position = @first_allowed_position + new_offset


    pass_through_rounds = case direction do
          "L" ->
            first_step_to_zero = case rem(position, iteration_size) do
                0 -> iteration_size
                r -> r
              end

            pass_through_zero =
                if first_step_to_zero > distance do
                    0
                else
                    1 + div(distance - first_step_to_zero, iteration_size)
                end

                pass_through_zero
          "R" ->
            first_step_to_zero =
                if rem(position, iteration_size) == 0 do
                  iteration_size
                else
                  iteration_size - rem(position, iteration_size)
                end

            pass_through_zero =
                if first_step_to_zero > distance do
                  0
                else
                  1 + div(distance - first_step_to_zero, iteration_size)
                end

            pass_through_zero
        end



    new_pass_through = pass_through +  pass_through_rounds

    IO.puts("New Position: #{new_position}, Pass Through Addition: #{pass_through_rounds}")

    new_counter =
      if new_position == @reference_position do
        counter + 1
      else
        counter
      end

    {new_position, new_counter, new_pass_through}
  end

  def execute(path) do
    {:ok, contents} = File.read(path)

    {final_position, final_counter, pass_through} =
        contents
        |> String.split("\n", trim: true)
        |> Enum.reduce({@start_position, @start_counter, @start_pass_through}, &move/2)

    IO.puts("Final position: #{final_position}, Final counter: #{final_counter}")
    IO.puts("Pass through: #{pass_through}")
  end

  def run([]) do
    execute("lib/day1/input.txt")
  end

  def run([path | _]) do
    execute(path)
  end
end
