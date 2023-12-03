defmodule AOC.Day02b do
  use AOC

  @type cube_color :: :red | :green | :blue
  @type id :: integer()
  @type pull :: %{optional(cube_color()) => integer()}
  @type game :: %{pulls: list(pull()), maxes: pull()}
  @type games :: %{id() => game()}
  @type power :: integer()

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_game/1)
    |> Enum.map(&calculate_power/1)
    |> Enum.sum()
  end

  @spec calculate_power({id(), game()}) :: power()
  def calculate_power({_id, game}) do
    game.maxes.red * game.maxes.green * game.maxes.blue
  end

  @spec parse_game(String.t()) :: {id(), game()}
  def parse_game(line) do
    ["Game " <> id, raw_game] = String.split(line, ": ")
    pulls = parse_pulls(raw_game)
    {String.to_integer(id), %{pulls: pulls, maxes: find_maxes(pulls)}}
  end

  @spec parse_pulls(String.t()) :: list(pull())
  def parse_pulls(raw_game) do
    raw_game
    |> String.split("; ")
    |> Enum.map(&parse_pull/1)
  end

  @spec parse_pull(String.t()) :: pull()
  def parse_pull(raw_pull) do
    raw_pull
    |> String.split(", ")
    |> Enum.map(&parse_color/1)
    |> Map.new()
  end

  @spec parse_color(String.t()) :: {atom(), integer()}
  def parse_color(raw_color) do
    [count, color] = String.split(raw_color, " ")
    {String.to_atom(color), String.to_integer(count)}
  end

  @spec find_maxes(list(pull())) :: pull()
  def find_maxes(pulls) do
    pulls
    |> Enum.reduce(%{red: 0, green: 0, blue: 0}, &update_maxes/2)
  end

  @spec update_maxes(pull(), pull()) :: pull()
  def update_maxes(pull, maxes) do
    maxes
    |> Enum.map(&update_max(&1, pull))
    |> Map.new()
  end

  @spec update_max({cube_color(), integer()}, pull()) :: {cube_color(), integer()}
  def update_max({color, count}, pull) do
    {color, max(Map.get(pull, color, 0), count)}
  end
end
