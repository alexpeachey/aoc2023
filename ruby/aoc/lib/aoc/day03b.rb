module AOC
  class Day03b < Day
    def sum_gear_ratios
      gear_ratios.sum
    end

    def gear_ratios
      @gear_ratios ||= grid_map.select(&method(:asterisk?))
        .map(&method(:parts_for_asterisk))
        .select {|parts| parts.length == 2}
        .map(&method(:gear_ratio))
    end

    def asterisk?(_coordinate, character)
      character == "*"
    end

    def parts_for_asterisk(asterisk)
      coordinate, _ = asterisk
      part_numbers.select {|part| part_number_near_coordinate?(part, coordinate)}
        .map do |part|
          part_number, _coordinates = part
          part_number.to_i
        end
    end

    def part_number_near_coordinate?(part, coordinate)
      _part_number, coordinates = part
      coordinates.any? {|part_coordinate| near_coordinate?(part_coordinate, coordinate)}
    end

    def near_coordinate?(part_coordinate, coordinate)
      x1, y1 = part_coordinate
      x2, y2 = coordinate
      (x1 - x2).abs <= 1 && (y1 - y2).abs <= 1
    end

    def gear_ratio(parts)
      part1, part2 = parts
      part1 * part2
    end

    def part_numbers
      @part_numbers ||= numbers.select(&method(:part_number?))
    end

    def part_number?(number)
      _, coordinates = number
      coordinates.any?(&method(:near_symbol?))
    end

    def near_symbol?(coordinate)
      x, y = coordinate
      [[x-1,y],[x+1,y],[x,y-1],[x,y+1],[x+1,y+1],[x-1,y+1],[x+1,y-1],[x-1,y-1]].any?(method(:symbol?))
    end

    def symbol?(coordinate)
      return false if grid_map[coordinate].nil?
      return false if grid_map[coordinate] == "."
      return false if grid_map[coordinate] =~ /\d/
      true
    end

    def numbers
      @numbers ||= grid_map.select(&method(:number?))
        .to_a
        .sort(&method(:cell_sorter))
        .chunk_while(&method(:contiguous_digits?))
        .map(&method(:number_with_coordinates))
    end

    def number_with_coordinates(chunk)
      chunk.reduce(["", []]) do |memo, cell|
        coordinate, digit = cell
        number, coordinates = memo
        [number + digit, coordinates.push(coordinate)]
      end
    end

    def contiguous_digits?(cell1, cell2)
      coordinate1, _ = cell1
      coordinate2, _ = cell2
      x1, y1 = coordinate1
      x2, y2 = coordinate2
      y1 == y2 && x2 - x1 == 1
    end

    def cell_sorter(cell1, cell2)
      coordinate1, _ = cell1
      coordinate2, _ = cell2
      x1, y1 = coordinate1
      x2, y2 = coordinate2
      return 0 if x1 == x2 && y1 == y2
      return -1 if y1 < y2
      return -1 if y1 == y2 && x1 < x2
      1
    end

    def number?(_coordinate, character)
      character =~ /\d/
    end

    def grid_map
      return @grid_map if @grid_map
      map = {}
      grid.each_with_index do |row, y|
        row.each_with_index { |cell, x| map[[x, y]] = cell }
      end
      @grid_map = map
    end

    def grid
      @grid ||= File.readlines(@path, chomp: true)
        .map { |line| line.split("") }
    end
  end
end
