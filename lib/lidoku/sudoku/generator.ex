defmodule Lidoku.Sudoku.Generator do

  def generate_puzzle(n \\ 0) do
    pluck(construct_puzzle_solution(), n)
  end

  def construct_puzzle_solution() do
    case reduce_puzzle_solution() do
      :error -> construct_puzzle_solution()
      result -> result.puzzle
    end
  end

  defp reduce_puzzle_solution() do
    init_acc = %{
      puzzle: Tuple.duplicate(0, 81),
      rows: generate_sudoku_units(),
      columns: generate_sudoku_units(),
      squares: generate_sudoku_units(),
    }
    Enum.reduce_while(Enum.to_list(0..80), init_acc, fn index, acc ->
      try do
        row = div(index, 9)
        col = rem(index, 9)
        row_choices = elem(acc.rows, row)
        col_choices = elem(acc.columns, col)
        square_choices = elem(acc.squares, (div(row,3)*3)+div(col,3))
        choices = intersection([row_choices, col_choices, square_choices])
        choice = Enum.random(choices)
        {:cont, %{
          puzzle: put_elem(acc.puzzle, row*9+col, choice),
          rows: put_elem(acc.rows, row, MapSet.delete(row_choices, choice)),
          columns: put_elem(acc.columns, col, MapSet.delete(col_choices, choice)),
          squares: put_elem(acc.squares, (div(row,3)*3)+div(col,3), MapSet.delete(square_choices, choice))
        }}
      rescue
        _ -> {:halt, :error}
      end
    end)
  end

  defp generate_sudoku_units() do
    Tuple.duplicate(Enum.to_list(1..9) |> MapSet.new, 9)
  end

  defp intersection([head]), do: head
  defp intersection([head | tail]) do
    Enum.reduce(tail, head, fn x, acc -> MapSet.intersection(x, acc) end)
  end

  def pluck(puzzle, n \\ 0) do
    pluck(puzzle, n, MapSet.new(Enum.to_list(0..80)), MapSet.new(Enum.to_list(0..80)))
  end

  defp pluck(puzzle, n, cells, cells_left) do
    if MapSet.size(cells) <= n or MapSet.size(cells_left) <= 0 do
      {puzzle, MapSet.size(cells)}
    else
        cell = Enum.random(cells_left)
        cells_left = MapSet.delete(cells_left, cell)
        with true <- test_pluck(puzzle, false, false, false, 0, cell) do
          pluck(puzzle, n, cells, cells_left)
        else
          _ ->
            puzzle = put_elem(puzzle, cell, 0)
            cells = MapSet.delete(cells, cell)
            pluck(puzzle, n, cells, cells_left)
        end
    end
  end

  defp test_pluck(puzzle, row, col, square, index, cell) do
    cond do
      index > 8 -> row and col and square
      row and col and square -> true
      true ->
        row = index != div(cell, 9) and possible?(puzzle, index, rem(cell, 9), cell)
        col = index != rem(cell, 9) and possible?(puzzle, div(cell, 9), index, cell)
        square = !(div(div(cell, 9),3)*3+div(index,3)==div(cell,9) and rem(div(cell,9),3)*3+rem(index,3)==rem(cell,9)) and possible?(puzzle, div(div(cell,9),3)*3+div(index,3), rem(div(cell,9),3)*3+rem(index,3), cell)
        test_pluck(puzzle, row, col, square, index+1, cell)
    end
  end

  defp possible?(puzzle, row, col, cell) do
    value = elem(puzzle, cell)
    index = row*9+col
    cond do
      elem(puzzle, index) == value -> true
      Enum.member?(Enum.to_list(1..9), elem(puzzle, index)) -> false
      true -> test_group(puzzle, row, col, cell, value)
    end
  end

  defp test_group(puzzle, row, col, cell, value) do
    test_group(puzzle, 0, row, col, cell, value)
  end

  defp test_group(puzzle, m, row, col, cell, value) do
    cond do
      m > 8 -> true
      !(m==div(cell,9) and col==rem(cell,9)) and elem(puzzle,m*9+col) == value -> false
      !(row==div(cell,9) and m==rem(cell,9)) and elem(puzzle,row*9+m) == value -> false
      !(div(row,3)*3+div(m,3)==div(cell,9) and div(col,3)*3+rem(m,3)==rem(cell,9)) and elem(puzzle,((div(row,3)*3+div(m,3))*9)+(div(col,3)*3+rem(m,3)))==value -> false
      true -> test_group(puzzle, m+1, row, col, cell, value)
    end
  end
end
