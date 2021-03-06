# tuples are laid out consecutively in memory
# tuples can't be updated in place!!!
#
# this is different from the previous versions in that
# - the grid is just a 1d-tuple (not a 2d tuple)
# - no Stream usage

defmodule Sudoku do

  def string_to_sudoku(s) do
    String.graphemes(s) |> Enum.map(fn x -> String.to_integer(x) end) |> List.to_tuple
  end

  def to_string(sudoku) do
    for i <- 0..80 do
      elem(sudoku, i) |> Integer.to_string
    end |> Enum.join("")
  end

  def get(sudoku, row, col) do
    elem(sudoku, row*9+col)
  end

  # every value in elixir is immutable
  def copy_and_set(sudoku, row, col, v) do
    put_elem(sudoku, row*9+col, v)
  end

  @spec is_valid_group?(list(pos_integer())) :: boolean()
  def is_valid_group?(group) do
    without_zero = group |> Enum.filter(fn e -> e != 0 end)
    MapSet.new(without_zero) |> MapSet.size == without_zero |> Enum.count
  end

  def is_valid?(sudoku) do
    # rows
    all_valid_rows = for r <- 0..8 do
      for c <- 0..8 do
        Sudoku.get(sudoku, r, c)
      end |> Sudoku.is_valid_group?
    end |> Enum.all?

    # cols
    all_valid_cols = for c <- 0..8 do
      for r <- 0..8 do
        Sudoku.get(sudoku, r, c)
      end |> Sudoku.is_valid_group?
    end |> Enum.all?

    # boxes
    all_valid_boxes = for b <- 0..8 do
      box_row = div(b, 3)
      box_col = Integer.mod(b, 3)
      for r <- box_row*3..box_row*3+2 do
        for c <- box_col*3..box_col*3+2 do
          Sudoku.get(sudoku, r, c)
        end
      end |> Sudoku.is_valid_group?
    end |> Enum.all?

    all_valid_rows and all_valid_cols and all_valid_boxes
  end

  # return nil or next position
  def next_open(sudoku) do
    # if there are no rows with an open column return nil
    index = Enum.find(0..80, fn i -> elem(sudoku, i) == 0 end)
    if index do
      row = div(index, 9)
      col = Integer.mod(index, 9)
      {row, col}
    else
      nil
    end
  end

  def solve(sudoku) do
    case Sudoku.solve_internal(sudoku) do
      {true, s} -> s
      {false, _} -> nil
    end
  end

  # I hate how it's really hard to line up all the `end` statements
  def solve_internal(sudoku) do
    if not Sudoku.is_valid?(sudoku) do
      {false, nil}
    else
      next_pos = Sudoku.next_open(sudoku)
      case next_pos do
        nil -> {true, sudoku}
        {r, c} ->
          any = Enum.find_value(1..9, fn v ->
            new_sudoku = Sudoku.copy_and_set(sudoku, r, c, v)
            {is_done, solved_sudoku} = Sudoku.solve_internal(new_sudoku)
            if is_done do
              {true, solved_sudoku}
            else
              nil
            end
          end)
          case any do
            nil -> {false, nil}
            {true, s} -> {true, s}
            {false, _} -> {false, nil}
          end
      end
    end
  end
end

# brutally slow, but it works...
defmodule Main do
  def main do
    s = Sudoku.string_to_sudoku("801340000430800107000060003208050009009000700600070804300010000105006042000024308")
    IO.puts(Sudoku.to_string(s))
    IO.puts(Sudoku.to_string(Sudoku.solve(s)))
  end
end

Main.main
