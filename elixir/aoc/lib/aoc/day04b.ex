defmodule AOC.Day04b do
  use AOC

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(&parse_card/1)
    |> Map.new()
    |> process_cards()
    |> Enum.map(fn {_id, {_score, count}} -> count end)
    |> Enum.sum()
  end

  def process_cards(cards) do
    cards
    |> Map.keys()
    |> Enum.sort()
    |> Enum.reduce(cards, &process_card/2)
  end

  def process_card(id, cards) do
    updated = copy_cards(id, cards[id], cards)
    Map.merge(cards, updated)
  end

  def copy_cards(_, {0, _}, _cards), do: %{}

  def copy_cards(id, {score, count}, cards) do
    (id + 1)..(id + score)
    |> Enum.map(&copy_card(&1, count, cards))
    |> Map.new()
  end

  def copy_card(id, duplicates, cards) do
    {score, count} = cards[id]
    {id, {score, count + duplicates}}
  end

  def parse_card([card_ref, numbers]) do
    id = card_ref |> String.split(" ", trim: true) |> List.last()
    [winning, ticket] = numbers |> String.split(" | ")
    score = score_card([winning, ticket])
    {String.to_integer(id), {score, 1}}
  end

  def score_card([winning, ticket]) do
    winning_numbers = winning |> String.split(" ", trim: true)
    ticket_numbers = ticket |> String.split(" ", trim: true)

    ticket_numbers
    |> Enum.filter(&Enum.member?(winning_numbers, &1))
    |> Enum.count()
  end
end
