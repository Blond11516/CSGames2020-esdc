defmodule Solve do
  def find_max_for_lines(grid) do
    products =
      for y <- 0..19,
          line = Enum.at(grid, y) do
        for x <- 0..15 do
          Enum.reduce(
            for i <- x..(x + 3) do
              Enum.at(line, i)
            end,
            1,
            &Kernel.*/2
          )
        end
      end
      |> List.flatten()

    Enum.max(products)
  end

  def find_max_for_columns(grid) do
    grid
    |> transpose()
    |> find_max_for_lines()
  end

  def find_max_for_diagonals(grid) do
    products =
      for y <- 0..15 do
        for x <- 0..15 do
          terms =
            for {i, j} <- Enum.zip(y..(y + 3), x..(x + 3)),
                line = Enum.at(grid, i) do
              Enum.at(line, j)
            end
            |> List.flatten()

          Enum.reduce(terms, 1, &Kernel.*/2)
        end
      end
      |> List.flatten()

    Enum.max(products)
  end

  def mirror(grid) do
    for i <- 0..19 do
      Enum.at(grid, 19 - i)
    end
  end

  def transpose([[] | _]), do: []

  def transpose(m) do
    [Enum.map(m, &hd/1) | transpose(Enum.map(m, &tl/1))]
  end

  def solve do
    lines =
      File.read!("input.txt")
      |> String.trim()
      |> String.split("\n")

    grid =
      for line <- lines,
          numbers = String.split(line) do
        for number <- numbers,
            num = String.to_integer(number) do
          num
        end
      end

    maxes = [find_max_for_lines(grid)]
    maxes = [find_max_for_columns(grid) | maxes]
    maxes = [find_max_for_diagonals(grid) | maxes]
    maxes = [find_max_for_diagonals(mirror(grid)) | maxes]
    IO.inspect(Enum.max(maxes))
  end
end

Solve.solve()
