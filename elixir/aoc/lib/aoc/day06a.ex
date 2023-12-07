defmodule AOC.Day06a do
  use AOC

  def solution(path) do
    [times, distances] = path |> read_lines() |> Enum.map(&String.trim/1)
    [_, times] = times |> String.split(":", trim: true)
    times = times |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    [_, distances] = distances |> String.split(":", trim: true)
    distances = distances |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    races = Enum.zip(times, distances)

    races
    |> Enum.map(&winning_strategies/1)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def winning_strategies({time, distance}) do
    1..time
    |> Enum.filter(&winning?(&1, time, distance))
    |> Enum.count()
  end

  def winning?(holding, time, distance) do
    holding * (time - holding) > distance
  end
end
