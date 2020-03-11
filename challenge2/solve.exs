defmodule Solve do
  alias :math, as: Math

  def eratosthene([head | rest] = ints) do
    if Math.pow(head, 2) > List.last(rest) do
      ints
    else
      eratosthene(Enum.filter(rest, fn x -> rem(x, head) != 0 end))
    end
  end

  def is_prime?(nb) when nb in [0, 1], do: false

  def is_prime?(nb) when nb in [2, 3], do: true

  def is_prime?(nb) do
    is_prime?(nb, 2)
  end

  def is_prime?(nb, it) do
    if it * it > nb do
      true
    else
      if rem(nb, it) == 0 do
        false
      else
        is_prime?(nb, it + 1)
      end
    end
  end

  # Taken from https://elixirforum.com/t/most-elegant-way-to-generate-all-permutations/2706/2
  def permutations([]), do: [[]]

  def permutations(list) do
    for elem <- list,
        rest <- permutations(list -- [elem]) do
      [elem | rest]
    end
  end

  def is_circular_prime?(nb) do
    if rem(nb, 1000) == 0 do
      IO.inspect(nb)
    end

    nb
    |> Integer.to_string()
    |> String.split("")
    |> permutations()
    |> Enum.map(&to_int/1)
    |> Enum.all?(&is_prime?/1)
  end

  def to_int(list) do
    list
    |> Enum.join()
    |> String.to_integer()
  end

  def parallel_filter(enumerable, func) do
    enumerable
    |> Task.async_stream(func, ordered: false)
    |> Enum.filter(fn x -> x end)
  end

  def solve do
    erat = eratosthene(Enum.to_list(2..1_000_000))
    nb_circular_primes = length(parallel_filter(erat, &is_circular_prime?/1))

    IO.inspect(nb_circular_primes)
  end
end

Solve.solve()
