# frozen_string_literal: true

Dir[File.join(__dir__, "/aoc/**/*.rb")].sort.each { |file| require file }

module AOC
  class Error < StandardError; end
end
