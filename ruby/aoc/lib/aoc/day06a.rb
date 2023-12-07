module AOC
  class Day06a < Day
    def winning_combinations
      parse_input.map(&method(:winning_strategies)).reduce(1, &:*)
    end

    def winning_strategies(constraints)
      time, distance = constraints
      (1..time).select do |hold|
        hold * (time - hold) > distance
      end.count
    end

    def parse_input
      times, distances = File.readlines(@path, chomp: true)
      _, times = times.split(': ')
      times = times.split(" ").map(&:to_i)
      _, distances = distances.split(': ')
      distances = distances.split(" ").map(&:to_i)
      times.zip(distances)
    end
  end
end
