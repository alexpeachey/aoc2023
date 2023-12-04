defmodule AOC.Day03a do
  use AOC

  @type grid :: list(list(String.t()))
  @type coordinate :: {integer(), integer()}
  @type grid_map :: %{coordinate() => String.t()}
  @type number_map :: %{integer() => list(coordinate())}

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> create_grid_map()
    |> find_part_numbers()
    |> Enum.sum()
  end

  @spec create_grid_map(grid()) :: grid_map()
  def create_grid_map(grid) do
    grid
    |> Enum.with_index()
    |> Enum.map(&map_coordinates_to_characters/1)
    |> List.flatten()
    |> Map.new()
  end

  @spec map_coordinates_to_characters({list(String.t()), integer()}) :: {coordinate(), String.t()}
  def map_coordinates_to_characters({row, y}) do
    row
    |> Enum.with_index()
    |> Enum.map(fn {character, x} -> {{x, y}, character} end)
  end

  @spec find_part_numbers(grid_map()) :: list(integer())
  def find_part_numbers(grid_map) do
    grid_map
    |> find_numbers()
    |> Enum.filter(&part_number?(&1, grid_map))
    |> Enum.map(fn {number, _} -> number end)
    |> Enum.map(&String.to_integer/1)
  end

  @spec part_number?({String.t(), list(coordinate())}, grid_map()) :: boolean()
  def part_number?({_number, coordinates}, grid_map) do
    coordinates
    |> Enum.any?(&near_symbol(&1, grid_map))
  end

  @spec near_symbol(coordinate(), grid_map()) :: boolean()
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

  @spec symbol?(coordinate(), grid_map()) :: boolean()
  def symbol?(coordinate, grid_map) do
    character = Map.get(grid_map, coordinate)

    cond do
      character == nil -> false
      character == "." -> false
      String.match?(character, ~r/\d/) -> false
      true -> true
    end
  end

  @spec find_numbers(grid_map()) :: number_map()
  def find_numbers(grid_map) do
    grid_map
    |> Enum.filter(&number_cell?/1)
    |> Enum.sort(&sort_by_coordinate/2)
    |> Enum.chunk_while({}, &number_chunker/2, &number_finalizer/1)
  end

  @spec number_cell?({coordinate(), String.t()}) :: boolean()
  def number_cell?({_, character}) do
    String.match?(character, ~r/\d/)
  end

  @spec sort_by_coordinate({coordinate(), String.t()}, {coordinate(), String.t()}) :: boolean()
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
