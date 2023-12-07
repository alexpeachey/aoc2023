module AOC
  class Day06b < Day
    def winning_strategies
      time, distance = parse_input
      (1..time).select do |hold|
        hold * (time - hold) > distance
      end.count
    end

    def parse_input
      time, distance = File.readlines(@path, chomp: true)
      _, time = time.split(': ')
      time = time.gsub(" ", "").to_i
      _, distance = distance.split(': ')
      distance = distance.gsub(" ", "").to_i
      [time, distance]
    end
  end
end
