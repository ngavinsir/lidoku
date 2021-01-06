defmodule Lidoku.Sudoku.Generator do

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
end
