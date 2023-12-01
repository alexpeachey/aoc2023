defmodule AOC.Day01a do
  use AOC

  @type calibration_line :: String.t()
  @type calibration_sum :: integer()
  @type calibration_value :: integer()

  @spec solution(path()) :: calibration_sum()
  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&calibration_value/1)
    |> Enum.sum()
  end

  @spec calibration_value(calibration_line()) :: calibration_value()
  def calibration_value(line) do
    line
    |> String.replace(~r/[^\d)]/, "", global: true)
    |> first_and_last()
    |> String.to_integer()
  end

  @spec first_and_last(calibration_line()) :: calibration_line()
  def first_and_last(line) do
    "#{String.first(line)}#{String.last(line)}"
  end
end
