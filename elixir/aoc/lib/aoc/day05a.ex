defmodule AOC.Day05a do
  use AOC

  def solution(path) do
    path
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_mappings/1)
    |> Map.new()
    |> determine_locations()
    |> Enum.map(&elem(&1, 1))
    |> Enum.min()
  end

  def parse_mappings("seeds: " <> seeds) do
    seeds
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> then(fn list -> {:seeds, list} end)
  end

  def parse_mappings(block) do
    lines =
      block
      |> String.split("\n", trim: true)

    [name | mappings] = lines
    [name, _] = String.split(name, " ", trim: true)

    [source, destination] =
      name
      |> String.split("-to-", trim: true)
      |> Enum.map(&String.to_atom/1)

    conversions =
      mappings
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(&parse_mapping(&1, destination))
      |> List.insert_at(-1, {[], 0, destination})

    {source, conversions}
  end

  def parse_mapping([dstart, sstart, size], destination) do
    dstart = String.to_integer(dstart)
    sstart = String.to_integer(sstart)
    size = String.to_integer(size)
    offset = dstart - sstart
    {sstart..(sstart + size), offset, destination}
  end

  def determine_locations(mappings) do
    mappings.seeds
    |> Enum.map(fn seed -> {:seed, seed} end)
    |> Enum.map(&follow_mappings(&1, mappings))
  end

  def follow_mappings({:location, _} = result, _), do: result

  def follow_mappings({source, value}, mappings) do
    mapping = mappings[source]
    default = List.last(mapping)

    {_, offset, destination} =
      Enum.find(mapping, default, &in_range?(&1, value))

    follow_mappings({destination, value + offset}, mappings)
  end

  def in_range?({range, _, _}, value), do: Enum.member?(range, value)
end
