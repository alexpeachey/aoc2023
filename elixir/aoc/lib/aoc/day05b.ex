defmodule AOC.Day05b do
  use AOC

  def solution(path) do
    path
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_mappings/1)
    |> Map.new()
    |> determine_locations()
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(fn s.._ -> s end)
    |> Enum.min()
  end

  def parse_mappings("seeds: " <> seeds) do
    seeds
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&to_seed_range/1)
    |> Enum.sort(fn r1, r2 -> r1.first < r2.first end)
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
      |> Enum.sort(fn {s1, _, _}, {s2, _, _} -> s1 < s2 end)

    {source, conversions}
  end

  def to_seed_range([start, size]) do
    start..(start + size - 1)
  end

  def parse_mapping([dstart, sstart, size], destination) do
    dstart = String.to_integer(dstart)
    sstart = String.to_integer(sstart)
    size = String.to_integer(size)
    offset = dstart - sstart
    {sstart..(sstart + size - 1), offset, destination}
  end

  def determine_locations(mappings) do
    mappings.seeds
    |> Enum.map(fn seed -> {:seed, seed} end)
    |> Enum.map(&follow_mappings(&1, mappings))
    |> List.flatten()
  end

  def follow_mappings({:location, _} = result, _), do: result

  def follow_mappings({source, value}, mappings) do
    mapping = mappings[source]
    {_, _, destination} = List.last(mapping)

    mapping
    |> Enum.map(&generate_instructions(&1, value))
    |> Enum.reject(fn instruction -> elem(instruction, 0) == [] end)
    |> finalize_instructions(value, destination)
    |> Enum.map(&apply_instructions/1)
    |> Enum.map(&follow_mappings(&1, mappings))
  end

  def generate_instructions({ssource..esource, offset, destination}, sinput..einput)
      when ssource <= einput and esource >= sinput do
    {max(sinput, ssource)..min(einput, esource), offset, destination}
  end

  def generate_instructions({_, offset, destination}, _) do
    {[], offset, destination}
  end

  def finalize_instructions(instructions, input, destination) do
    instructions
    |> Enum.reject(fn instruction -> elem(instruction, 0) == [] end)
    |> Enum.reduce([input], &build_identity_ranges/2)
    |> Enum.map(fn range -> {range, 0, destination} end)
    |> then(fn identities -> instructions ++ identities end)
    |> Enum.dedup_by(fn {range, _, _} -> range end)
  end

  def build_identity_ranges({ssource..esource, _, _}, [sinput..einput | remaining])
      when ssource <= einput and esource >= sinput do
    [sinput..min(ssource - 1, einput), max(esource + 1, sinput)..einput]
    |> Enum.reject(&(&1.step != 1))
    |> Enum.reverse()
    |> then(fn list -> list ++ remaining end)
  end

  def build_identity_ranges(_, list), do: list

  def apply_instructions({sinput..einput, offset, destination}) do
    {destination, (sinput + offset)..(einput + offset)}
  end
end
