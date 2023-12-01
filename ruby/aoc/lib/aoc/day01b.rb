module AOC
  class Day01b
    @@matcher = /(?=(\d|one|two|three|four|five|six|seven|eight|nine))/
    @@number_map = {"one" => "1", "two" => "2", "three" => "3", "four" => "4", "five" => "5", "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9"}

    def initialize(path)
      @path = path
    end

    def calibrate
      File.readlines(@path, chomp: true)
        .map(&method(:calibration_value))
        .sum
    end

    private

    def calibration_value(line)
      digits = line.scan(@@matcher).flatten.map(&method(:number_to_digit))
      (digits[0] + digits[-1]).to_i
    end

    def number_to_digit(number)
      return number if /\d/.match?(number)
      @@number_map[number]
    end
  end
end
