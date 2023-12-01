defmodule AOC.Day01b do
  use AOC

  @type calibration_line :: String.t()
  @type calibration_sum :: integer()
  @type calibration_value :: integer()
  @type wordy_number :: String.t()
  @type word :: String.t()

  @matcher Regex.compile!("(?=(\\d|one|two|three|four|five|six|seven|eight|nine))")

  @number_map %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }

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
    |> String.trim()
    |> words_to_digits()
    |> first_and_last()
    |> String.to_integer()
  end

  @spec extract_digits(calibration_line()) :: calibration_line()
  def extract_digits(line) do
    line
    |> String.replace(~r/[^\d)]/, "", global: true)
  end

  @spec first_and_last(calibration_line()) :: calibration_line()
  def first_and_last(line) do
    "#{String.first(line)}#{String.last(line)}"
  end

  @spec words_to_digits(calibration_line()) :: calibration_line()
  def words_to_digits(line) do
    Regex.scan(@matcher, line, capture: :all_but_first)
    |> List.flatten()
    |> Enum.map(&number_to_digit/1)
    |> Enum.join()
  end

  @spec number_to_digit(wordy_number()) :: integer()
  def number_to_digit(number) do
    Map.get(@number_map, number) || String.to_integer(number)
  end
end
