defmodule AOC.Day06b do
  use AOC

  def solution(path) do
    [time, distance] = path |> read_lines() |> Enum.map(&String.trim/1)
    [_, time] = time |> String.split(":", trim: true)
    time = time |> String.replace(" ", "", global: true) |> String.to_integer()
    [_, distance] = distance |> String.split(":", trim: true)
    distance = distance |> String.replace(" ", "", global: true) |> String.to_integer()
    winning_strategies(time, distance)
  end

  def winning_strategies(time, distance) do
    1..time
    |> Enum.filter(&winning?(&1, time, distance))
    |> Enum.count()
  end

  def winning?(holding, time, distance) do
    holding * (time - holding) > distance
  end
end
