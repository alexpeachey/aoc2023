module AOC
  class Day04b < Day
    class Card
      attr_reader :id
      attr_reader :winning_numbers
      attr_reader :selected_numbers
      attr_accessor :copies

      def initialize(raw)
        game_ref, numbers = raw.split(": ")
        @id = game_ref.split(" ").last.to_i
        winning_numbers, selected_numbers = numbers.split(" | ")
        @winning_numbers = winning_numbers.split(" ").map(&:to_i)
        @selected_numbers = selected_numbers.split(" ").map(&:to_i)
        @copies = 1
      end

      def matches
        @matches ||= (@winning_numbers & @selected_numbers).length
      end

      def score
        return 0 if matches == 0
        return 1 if matches == 1
        return 2 ** (matches - 1)
      end

      def process(cards)
        ((id + 1)..(matches + id)).each do |i|
          card = cards.find { |c| c.id == i }
          card.copies += @copies
        end
      end
    end

    def sum_copies
      cards.each { |card| card.process(cards) }
      cards.map(&:copies).sum
    end

    def cards
      @cards ||= File.readlines(@path, chomp: true).map do |line|
        Card.new(line)
      end
    end
  end
end
