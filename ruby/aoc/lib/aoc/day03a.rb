module AOC
  class Day03a < Day
    def sum_part_numbers
      part_numbers.map(&:first).map(&:to_i).sum
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
