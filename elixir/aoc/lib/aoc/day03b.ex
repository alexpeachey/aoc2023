defmodule AOC.Day03b do
  use AOC

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> create_grid_map()
    |> find_gear_ratios()
    |> Enum.sum()
  end

  def find_gear_ratios(grid_map) do
    part_numbers = find_part_numbers(grid_map)

    grid_map
    |> Enum.filter(&asterisk_cell?/1)
    |> Enum.map(&parts_for_asterisk(&1, part_numbers))
    |> Enum.filter(fn parts -> length(parts) == 2 end)
    |> Enum.map(fn [part1, part2] -> part1 * part2 end)
  end

  def asterisk_cell?({_, "*"}), do: true
  def asterisk_cell?(_), do: false

  def parts_for_asterisk({coordinate, _}, part_numbers) do
    part_numbers
    |> Enum.filter(&part_close_to_coordinate?(&1, coordinate))
    |> Enum.map(fn {number, _} -> String.to_integer(number) end)
  end

  def part_close_to_coordinate?({_number, coordinates}, coordinate) do
    coordinates
    |> Enum.any?(&close_to_coordinate?(&1, coordinate))
  end

  def close_to_coordinate?({x1, y1}, {x2, y2}) do
    abs(x1 - x2) <= 1 and abs(y1 - y2) <= 1
  end

  def create_grid_map(grid) do
    grid
    |> Enum.with_index()
    |> Enum.map(&map_coordinates_to_characters/1)
    |> List.flatten()
    |> Map.new()
  end

  def map_coordinates_to_characters({row, y}) do
    row
    |> Enum.with_index()
    |> Enum.map(fn {character, x} -> {{x, y}, character} end)
  end

  def find_part_numbers(grid_map) do
    grid_map
    |> find_numbers()
    |> Enum.filter(&part_number?(&1, grid_map))
  end

  def part_number?({_number, coordinates}, grid_map) do
    coordinates
    |> Enum.any?(&near_symbol(&1, grid_map))
  end

  def near_symbol({x, y}, grid_map) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
      {x - 1, y - 1},
      {x + 1, y + 1},
      {x - 1, y + 1},
      {x + 1, y - 1}
    ]
    |> Enum.any?(&symbol?(&1, grid_map))
  end

  def symbol?(coordinate, grid_map) do
    character = Map.get(grid_map, coordinate)

    cond do
      character == nil -> false
      character == "." -> false
      String.match?(character, ~r/\d/) -> false
      true -> true
    end
  end

  def find_numbers(grid_map) do
    grid_map
    |> Enum.filter(&number_cell?/1)
    |> Enum.sort(&sort_by_coordinate/2)
    |> Enum.chunk_while({}, &number_chunker/2, &number_finalizer/1)
  end

  def number_cell?({_, character}) do
    String.match?(character, ~r/\d/)
  end

  def sort_by_coordinate({{x, y}, _}, {{x, y}, _}), do: true
  def sort_by_coordinate({{_, y1}, _}, {{_, y2}, _}) when y1 < y2, do: true
  def sort_by_coordinate({{x1, y}, _}, {{x2, y}, _}) when x1 <= x2, do: true
  def sort_by_coordinate(_, _), do: false

  def number_chunker({coordinate, character}, {}), do: {:cont, {character, [coordinate]}}

  def number_chunker({{x1, y} = coordinate, character}, {number, [{x2, y} | _] = coordinates})
      when x1 - x2 == 1 do
    {:cont, {number <> character, [coordinate | coordinates]}}
  end

  def number_chunker({coordinate, character}, {number, coordinates}) do
    {:cont, {number, coordinates}, {character, [coordinate]}}
  end

  def number_finalizer({}), do: {:cont, {}}
  def number_finalizer({number, coordinates}), do: {:cont, {number, coordinates}, {}}
end
