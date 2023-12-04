module AOC
  class Day04a < Day
    class Card
      attr_reader :id
      attr_reader :winning_numbers
      attr_reader :selected_numbers

      def initialize(raw)
        game_ref, numbers = raw.split(": ")
        @id = game_ref.split(" ").last.to_i
        winning_numbers, selected_numbers = numbers.split(" | ")
        @winning_numbers = winning_numbers.split(" ").map(&:to_i)
        @selected_numbers = selected_numbers.split(" ").map(&:to_i)
      end

      def matches
        @matches ||= (@winning_numbers & @selected_numbers).length
      end

      def score
        return 0 if matches == 0
        return 1 if matches == 1
        return 2 ** (matches - 1)
      end
    end

    def sum_scores
      cards.map(&:score).sum
    end

    def cards
      @cards ||= File.readlines(@path, chomp: true).map do |line|
        Card.new(line)
      end
    end
  end
end
