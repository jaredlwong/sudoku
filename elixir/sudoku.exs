defmodule Sudoku do
  @enforce_keys [:grid]
  defstruct [:grid]

  def new(grid) do
    %Sudoku{grid: grid}
  end

  def to_string(sudoku) do
    # sudoku.grid |> Tuple.to_list |> Enum.map(fn row -> row |> Tuple.to_list |> Enum.join(" ") end) |> Enum.join("\n")
    sudoku.grid |> Tuple.to_list |> Enum.map(fn row -> row |> Tuple.to_list |> Enum.join("") end) |> Enum.join("")
  end

  def get(sudoku, row, col) do
    sudoku.grid |> elem(row) |> elem(col)
  end

  # every value in elixir is immutable
  def copy_and_set(sudoku, row, col, v) do
    new_row = sudoku.grid |> elem(row) |> put_elem(col, v)
    %{sudoku | grid: put_elem(sudoku.grid, row, new_row)}
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
    s = Stream.flat_map 0..8, fn r ->
      Stream.flat_map 0..8, fn c ->
        if Sudoku.get(sudoku, r, c) == 0 do [{r, c}] else [] end
      end
    end
    s |> Stream.take(1) |> Enum.to_list |> List.first
  end

  def solve(sudoku) do
    case Sudoku.solve_internal(sudoku) do
      {true, s} -> s
      {false, _} -> nil
    end
  end

  # I hate how it's really hard to line up all the `end` statements
  # This method is brutally slow, the reason it's slow is the copy_and_set
  # function but elixir doesn't allow updating things in place which is awful
  # for performance.
  def solve_internal(sudoku) do
    if not Sudoku.is_valid?(sudoku) do
      {false, nil}
    else
      next_pos = Sudoku.next_open(sudoku)
      case next_pos do
        nil -> {true, sudoku}
        {r, c} ->
          any = Stream.take(Stream.flat_map(1..9, fn v ->
            new_sudoku = Sudoku.copy_and_set(sudoku, r, c, v)
            {is_done, solved_sudoku} = Sudoku.solve_internal(new_sudoku)
            if is_done do
              [{true, solved_sudoku}]
            else
              []
            end
          end), 1) |> Enum.to_list |> List.first
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
    s = Sudoku.new({
      {8, 0, 1, 3, 4, 0, 0, 0, 0},
      {4, 3, 0, 8, 0, 0, 1, 0, 7},
      {0, 0, 0, 0, 6, 0, 0, 0, 3},
      {2, 0, 8, 0, 5, 0, 0, 0, 9},
      {0, 0, 9, 0, 0, 0, 7, 0, 0},
      {6, 0, 0, 0, 7, 0, 8, 0, 4},
      {3, 0, 0, 0, 1, 0, 0, 0, 0},
      {1, 0, 5, 0, 0, 6, 0, 4, 2},
      {0, 0, 0, 0, 2, 4, 3, 0, 8}
    })
    IO.puts(Sudoku.to_string(s))
    IO.puts(Sudoku.to_string(Sudoku.solve(s)))
  end
end

Main.main
