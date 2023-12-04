defmodule AOC.Day04a do
  use AOC

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [_card, numbers] -> numbers end)
    |> Enum.map(&String.split(&1, " | "))
    |> Enum.map(&score_card/1)
    |> Enum.sum()
  end

  def score_card([winning, ticket]) do
    winning_numbers = winning |> String.split(" ", trim: true)
    ticket_numbers = ticket |> String.split(" ", trim: true)

    ticket_numbers
    |> Enum.filter(&Enum.member?(winning_numbers, &1))
    |> Enum.count()
    |> matches_to_score()
  end

  def matches_to_score(0), do: 0
  def matches_to_score(1), do: 1
  def matches_to_score(n), do: 2 ** (n - 1)
end
