# this attempt tries to use erlang term storage
# https://elixirschool.com/en/lessons/specifics/ets/
#
# this attempt tries to use Enum.find_value rather than Stream.*

defmodule Sudoku do
  @enforce_keys [:grid]
  defstruct [:grid]

  def new(s) do
    # https://elixirschool.com/en/lessons/specifics/ets/
    grid = :ets.new(:grid, [:set, :protected])
    for r <- 0..8 do
      for c <- 0..8 do
        value = String.at(s, r*9+c) |> String.to_integer
        # grid is actually an ETS id
        # the first element is the key, everything after in the tuple is the data (like a table)
        :ets.insert(grid, {r*9+c, value})
      end
    end
    %Sudoku{grid: grid}
  end

  def to_string(sudoku) do
    for r <- 0..8 do
      for c <- 0..8 do
        # [{0, 8}] |> {0, 8} |> 8 |> "8"
        :ets.lookup(sudoku.grid, r*9+c) |> List.first |> elem(1) |> Integer.to_string
      end |> Enum.join("")
    end |> Enum.join("")
  end

  def get(sudoku, row, col) do
    # [{0, 8}] |> {0, 8} |> 8
    :ets.lookup(sudoku.grid, row*9+col) |> List.first |> elem(1)
  end

  def set(sudoku, row, col, value) do
    :ets.insert(sudoku.grid, {row*9+col, value})
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
      Enum.flat_map(box_row*3..box_row*3+2, fn r ->
        for c <- box_col*3..box_col*3+2 do
          Sudoku.get(sudoku, r, c)
        end |> Enum.to_list
      end) |> Sudoku.is_valid_group?
    end |> Enum.all?

    all_valid_rows and all_valid_cols and all_valid_boxes
  end

  # return nil or next position
  def next_open(sudoku) do
    # if there are no rows with an open column return nil
    Enum.find_value(0..8, fn r ->
      # if there exists a column which is empty return the columns index, otherwise nil
      col = Enum.find_value(0..8, fn c ->
        if Sudoku.get(sudoku, r, c) == 0 do c else nil end
      end)
      # if there was a non-empty column in this row return the tuple of {row,
      # column} otherwise advance to next row
      if col == nil do nil else {r, col} end
    end)
  end

  def solve(sudoku) do
    if not Sudoku.is_valid?(sudoku) do
      false
    else
      next_pos = Sudoku.next_open(sudoku)
      case next_pos do
        # it's complete
        nil -> true
        {r, c} ->
          done = Enum.find_value(1..9, fn v ->
            # this updates the ETS in place
            Sudoku.set(sudoku, r, c, v)
            is_done = Sudoku.solve(sudoku)
            # unset the value
            if !is_done do Sudoku.set(sudoku, r, c, 0) end
            is_done
          end)
          case done do
            # if we eval all of 1..9 and they aren't true
            nil -> false
            true -> true
            false -> false
          end
      end
    end
  end
end

# brutally slow, but it works...
defmodule Main do
  def main do
    s = Sudoku.new("801340000430800107000060003208050009009000700600070804300010000105006042000024308")
    IO.puts(Sudoku.to_string(s))
    Sudoku.solve(s)
    IO.puts(Sudoku.to_string(s))
  end
end

Main.main
