module AOC
  class Day01a
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
      digits = line.gsub(/[^\d]/, "")
      (digits[0] + digits[-1]).to_i
    end
  end
end
